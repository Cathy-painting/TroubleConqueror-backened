"""
OCR 服务模块（百度通用文字识别 API 版）

功能：
- 接收前端 POST 请求：{"image_path": "/absolute/path/to/image.jpg"}
- 调用百度 OCR API 识别文字
- 返回识别结果 JSON：{"text": "识别结果文本"}

运行：
uvicorn ocr_service:app --host 0.0.0.0 --port 9000
"""

from fastapi import FastAPI, HTTPException, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
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
    allow_origins=["*"],  # 允许所有前端访问
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 百度 OCR 配置
# BAIDU_OCR_URL = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic"


BAIDU_OCR_URL = "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic"
ACCESS_TOKEN = "24.0018c369225cff45750d49dd51004d45.2592000.1767343705.282335-121154390"


# JSON 请求模型


class OCRRequest(BaseModel):
    image_path: str
    language_type: Optional[str] = "CHN_ENG"
    detect_direction: Optional[bool] = False
    detect_language: Optional[bool] = False
    paragraph: Optional[bool] = False
    probability: Optional[bool] = False


def call_baidu_ocr(
    img_bytes,
    language_type="CHN_ENG",
    detect_direction=False,
    detect_language=False,
    paragraph=False,
    probability=False,
):
    img_base64 = base64.b64encode(img_bytes).decode()
    url = f"{BAIDU_OCR_URL}?access_token={ACCESS_TOKEN}"
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    data = {
        "image": img_base64,
        "language_type": language_type,
        "detect_direction": str(detect_direction).lower(),
        "detect_language": str(detect_language).lower(),
        "paragraph": str(paragraph).lower(),
        "probability": str(probability).lower(),
    }
    resp = requests.post(url, headers=headers, data=data, timeout=30)
    if resp.status_code != 200:
        raise HTTPException(
            status_code=resp.status_code, detail=f"百度API请求失败：{resp.text}"
        )
    result = resp.json()
    if "words_result" not in result:
        raise HTTPException(status_code=500, detail=f"OCR失败：{result}")
    text = "\n".join([item["words"] for item in result["words_result"]])
    return text


# ==== JSON 路径模式 ====


@app.post("/ocr/json")
async def ocr_json(req: OCRRequest):
    p = Path(req.image_path)
    if not p.exists() or not p.is_file():
        raise HTTPException(status_code=400, detail=f"图片不存在: {req.image_path}")
    with open(p, "rb") as f:
        img_bytes = f.read()
    text = call_baidu_ocr(
        img_bytes,
        language_type=req.language_type,
        detect_direction=req.detect_direction,
        detect_language=req.detect_language,
        paragraph=req.paragraph,
        probability=req.probability,
    )
    return {"text": text}


# ==== 文件上传模式 ====


@app.post("/ocr/upload")
async def ocr_upload(
    file: UploadFile = File(...),
    language_type: str = Form("CHN_ENG"),
    detect_direction: bool = Form(False),
    detect_language: bool = Form(False),
    paragraph: bool = Form(False),
    probability: bool = Form(False),
):
    try:
        img_bytes = await file.read()
        text = call_baidu_ocr(
            img_bytes,
            language_type,
            detect_direction,
            detect_language,
            paragraph,
            probability,
        )
        return {"text": text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
