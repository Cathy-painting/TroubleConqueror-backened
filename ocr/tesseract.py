"""
OCR 服务模块

功能：
- 接收前端的 POST 请求，内容为 JSON：{"image_path": "/absolute/path/to/image.jpg"}
- 在临时目录中调用本地 tesseract：tesseract <image_path> <temp_dir>/ocr -l chi_sim+eng --oem 3
- 读取生成的 ocr.txt 内容，返回给前端，并清理临时文件和目录

运行：
uvicorn ocr_service:app --host 0.0.0.0 --port 9000

示例请求：
POST /ocr
Content-Type: application/json
{
  "image_path": "/path/to/image.png"
}

返回 JSON：{ "text": "识别结果文本" }

注意：
- 请确保服务器能访问传来的图片路径。
- 本模块通过 subprocess 调用系统上的 tesseract。请确保 tesseract 已安装且在 PATH 中。

"""
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import subprocess
import tempfile
import shutil
from pathlib import Path
import os
import logging
from typing import Optional

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

# 允许跨域
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class OCRRequest(BaseModel):
    image_path: str
    # 可选：识别语言、OEM、PSM 等
    lang: Optional[str] = "chi_sim+eng"
    oem: Optional[int] = 3
    psm: Optional[int] = None
    timeout: Optional[int] = 30


@app.post("/ocr")
async def do_ocr(req: OCRRequest):
    image_path = req.image_path
    lang = req.lang
    oem = req.oem
    psm = req.psm
    timeout = req.timeout

    p = Path(image_path)
    if not p.exists():
        raise HTTPException(status_code=400, detail=f"图片文件不存在: {image_path}")
    if not p.is_file():
        raise HTTPException(status_code=400, detail=f"不是文件: {image_path}")

    tempdir = tempfile.mkdtemp(prefix="ocr_tmp_")
    output_base = os.path.join(tempdir, "ocr")
    try:
        cmd = ["tesseract", image_path, output_base,
               "-l", lang, "--oem", str(oem)]
        if psm is not None:
            cmd += ["--psm", str(psm)]

        logger.info("Run tesseract: %s", " ".join(cmd))
        try:
            proc = subprocess.run(cmd, capture_output=True,
                                  text=True, timeout=timeout)
        except FileNotFoundError:
            raise HTTPException(
                status_code=500, detail="tesseract 未找到，请确认已安装并在 PATH 中")
        except subprocess.TimeoutExpired:
            raise HTTPException(status_code=504, detail="tesseract 运行超时")

        if proc.returncode != 0:
            stderr = proc.stderr.strip() if proc.stderr else ""
            raise HTTPException(
                status_code=500, detail=f"tesseract 失败: {stderr}")

        txt_path = output_base + ".txt"
        if not os.path.exists(txt_path):
            raise HTTPException(status_code=500, detail="OCR 输出文件未生成")

        with open(txt_path, "r", encoding="utf-8") as f:
            text = f.read()

        # 返回识别文本
        return {"text": text}

    finally:
        # 清理临时目录（包括 ocr.txt）
        try:
            shutil.rmtree(tempdir)
            logger.info("Removed tempdir %s", tempdir)
        except Exception as e:
            logger.warning("清理临时目录失败: %s", e)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("ocr_service:app", host="0.0.0.0", port=9000, log_level="info")
