"""
OCR 服务模块（百度通用文字识别 API 版）

功能：
- 接收前端 POST 请求：{"image_path": "/absolute/path/to/image.jpg"}
- 调用百度 OCR API 识别文字
- 返回识别结果 JSON：{"text": "识别结果文本"}

运行：
uvicorn ocr_service:app --host 0.0.0.0 --port 9000
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import base64
import requests
from pathlib import Path
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
    language_type: Optional[str] = "CHN_ENG"
    detect_direction: Optional[bool] = False
    detect_language: Optional[bool] = False
    paragraph: Optional[bool] = False
    probability: Optional[bool] = False


# ==== 百度 OCR 配置 ====
BAIDU_OCR_URL = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic"
# 替换为你自己的 access_token
ACCESS_TOKEN = "替换为你自己的Access_Token"


@app.post("/ocr")
async def do_ocr(req: OCRRequest):
    image_path = req.image_path
    p = Path(image_path)

    if not p.exists():
        raise HTTPException(status_code=400, detail=f"图片文件不存在: {image_path}")
    if not p.is_file():
        raise HTTPException(status_code=400, detail=f"不是文件: {image_path}")

    try:
        # 1. 读取并Base64编码
        with open(image_path, "rb") as f:
            img_data = f.read()
        img_base64 = base64.b64encode(img_data).decode()

        # 2. 构造请求
        url = f"{BAIDU_OCR_URL}?access_token={ACCESS_TOKEN}"
        headers = {"Content-Type": "application/x-www-form-urlencoded"}
        data = {
            "image": img_base64,
            "language_type": req.language_type,
            "detect_direction": str(req.detect_direction).lower(),
            "detect_language": str(req.detect_language).lower(),
            "paragraph": str(req.paragraph).lower(),
            "probability": str(req.probability).lower()
        }

        # 3. 发送请求
        logger.info("调用百度OCR接口...")
        resp = requests.post(url, headers=headers, data=data, timeout=30)

        # 4. 解析响应
        if resp.status_code != 200:
            raise HTTPException(status_code=resp.status_code,
                                detail=f"百度API请求失败：{resp.text}")

        result = resp.json()

        # 5. 检查识别结果
        if "words_result" not in result:
            raise HTTPException(status_code=500, detail=f"OCR失败：{result}")

        text = "\n".join([item["words"] for item in result["words_result"]])
        return {"text": text}

    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=f"请求百度API失败: {e}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("ocr_service:app", host="0.0.0.0", port=9000, log_level="info")
