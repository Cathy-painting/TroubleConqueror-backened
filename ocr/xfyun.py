#!/usr/bin/env python
# -*- coding:utf-8 -*-

from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from pathlib import Path
from typing import Any
import base64
import requests
import hashlib
import hmac
import time
import json
import re
from email.utils import formatdate
from io import BytesIO
import logging

# 尝试加载 Pillow 用于图片尺寸检查
try:
    from PIL import Image

    PIL_AVAILABLE = True
except Exception:
    PIL_AVAILABLE = False

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ================= 讯飞 OCR 公式识别 配置 =================
XFYUN_APPID = "bd35fbf3"
XFYUN_API_KEY = "7c3b68c1d99e571ecddea7521911bb0c"
XFYUN_API_SECRET = "M2QxOTc3NWEyMzhlZjYwMjBlMGQ1ZGVl"

XFYUN_HOST = "rest-api.xfyun.cn"
XFYUN_URI = "/v2/itr"
XFYUN_URL = f"https://{XFYUN_HOST}{XFYUN_URI}"

MAX_B64_BYTES = 4 * 1024 * 1024  # base64 最大 4MB

BUSINESS_ENT = "teach-photo-print"
BUSINESS_AUE = "raw"


class OCRRequest(BaseModel):
    image_path: str


# ================= 工具函数 =================


def sha256_base64(data: bytes) -> str:
    digest = hashlib.sha256(data).digest()
    return base64.b64encode(digest).decode()


def hmac_sha256_base64(message: str, secret: str) -> str:
    mac = hmac.new(secret.encode(), message.encode(), hashlib.sha256)
    return base64.b64encode(mac.digest()).decode()


def make_signature_headers(body_bytes: bytes) -> dict:
    date_str = formatdate(time.time(), usegmt=True)
    digest_val = "SHA-256=" + sha256_base64(body_bytes)
    request_line = f"POST {XFYUN_URI} HTTP/1.1"

    signature_origin = (
        f"host: {XFYUN_HOST}\ndate: {date_str}\n{
            request_line}\ndigest: {digest_val}"
    )

    signature = hmac_sha256_base64(signature_origin, XFYUN_API_SECRET)

    auth_header = (
        f'api_key="{XFYUN_API_KEY}", algorithm="hmac-sha256", '
        f'headers="host date request-line digest", signature="{signature}"'
    )

    return {
        "Content-Type": "application/json",
        "Accept": "application/json,version=1.0",
        "Host": XFYUN_HOST,
        "Date": date_str,
        "Digest": digest_val,
        "Authorization": auth_header,
    }


def prepare_body_for_xfyun(image_b64: str) -> bytes:
    body = {
        "common": {"app_id": XFYUN_APPID},
        "business": {"ent": BUSINESS_ENT, "aue": BUSINESS_AUE},
        "data": {"image": image_b64},
    }
    return json.dumps(body, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def forward_to_xfyun(body_bytes: bytes):
    headers = make_signature_headers(body_bytes)
    resp = requests.post(XFYUN_URL, headers=headers,
                         data=body_bytes, timeout=30)
    try:
        return resp.status_code, resp.json()
    except Exception:
        return resp.status_code, {"msg": resp.text}


def check_image_dimensions(img_bytes: bytes):
    if not PIL_AVAILABLE:
        return
    try:
        im = Image.open(BytesIO(img_bytes))
        w, h = im.size
        if min(w, h) < 15 or max(w, h) > 4096:
            raise HTTPException(
                status_code=400,
                detail=f"图片尺寸不合规：最短边>=15px，最长边<=4096px，你的：{w}x{h}",
            )
    except HTTPException:
        raise
    except Exception:
        raise HTTPException(status_code=400, detail="无法解析图片尺寸")


def extract_text_from_xfyun(result: dict) -> str:
    """
    讯飞返回结构：
    data.region[n].recog.content
    需要全部拼接
    """
    try:
        regions = result["data"]["region"]
    except Exception:
        raise HTTPException(status_code=500, detail="响应格式异常：找不到 region")

    texts = []
    for r in regions:
        try:
            texts.append(r["recog"]["content"])
        except KeyError:
            continue

    if not texts:
        return ""

    return "\n".join(texts)


def convert_ifly_to_latex(text: str) -> str:
    """
    将讯飞 OCR 返回的 ifly-latex-begin ... ifly-latex-end 内容提取为标准 LaTeX。
    其他文字保留。
    """

    # 替换所有 ifly-latex-begin ... ifly-latex-end 为 $...$
    def repl(m):
        content = m.group(1)
        return f"${content}$"  # 或者用 \(...\) 也行

    pattern = r"ifly-latex-begin\s*(.*?)\s*ifly-latex-end"
    return re.sub(pattern, repl, text)


# ================= JSON 路径模式 =================


@app.post("/ocr/json")
async def ocr_json(req: OCRRequest):
    p = Path(req.image_path)
    if not p.exists() or not p.is_file():
        raise HTTPException(status_code=400, detail="图片不存在")

    img_bytes = p.read_bytes()
    check_image_dimensions(img_bytes)

    image_b64 = base64.b64encode(img_bytes).decode().replace("\n", "")
    if len(image_b64.encode()) > MAX_B64_BYTES:
        raise HTTPException(status_code=400, detail="base64图片超过4MB限制")

    body_bytes = prepare_body_for_xfyun(image_b64)
    status, result = forward_to_xfyun(body_bytes)

    if status != 200:
        raise HTTPException(status_code=502, detail=result)

    # 提取 content
    content_list = result.get("data", {}).get("region", [])
    text_raw = ""
    for r in content_list:
        text_raw += r.get("recog", {}).get("content", "") + "\n"

    # 转换为标准 LaTeX
    text = convert_ifly_to_latex(text_raw)
    return {"text": text}


# ================= 上传图片模式 =================


@app.post("/ocr/upload")
async def ocr_upload(file: UploadFile = File(...)):
    try:
        img_bytes = await file.read()
        if not img_bytes:
            raise HTTPException(status_code=400, detail="上传文件为空")

        check_image_dimensions(img_bytes)

        image_b64 = base64.b64encode(img_bytes).decode().replace("\n", "")
        if len(image_b64.encode()) > MAX_B64_BYTES:
            raise HTTPException(status_code=400, detail="base64图片超过4MB限制")

        body_bytes = prepare_body_for_xfyun(image_b64)
        status, result = forward_to_xfyun(body_bytes)

        if status != 200:
            raise HTTPException(status_code=502, detail=result)

        # 提取并转换 LaTeX
        text_raw = extract_text_from_xfyun(result)
        text = convert_ifly_to_latex(text_raw)
        return {"text": text}

    except HTTPException:
        raise
    except Exception as e:
        logger.exception("ocr_upload error")
        raise HTTPException(status_code=500, detail=str(e))
