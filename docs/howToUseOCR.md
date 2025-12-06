## OCR 服务模块运行与使用教程（Python + FastAPI）

### ① 环境准备

1. **进入项目目录**
   打开终端（Terminal）或 CMD，进入 `ocr` 文件夹：

   ```bash
   cd ocr
   ```

2. **检查 Python 版本**
   建议使用 Python 3.10/3.11/3.12：

   ```bash
   python --version
   ```

3. **创建虚拟环境**
   - **Linux / macOS**：

     ```bash
     python -m venv venv
     source venv/bin/activate
     ```

   - **Windows (CMD)**：

     ```cmd
     python -m venv venv
     venv\Scripts\activate
     ```

   - **Windows (PowerShell)**：

     ```powershell
     python -m venv venv
     .\venv\Scripts\Activate.ps1
     ```

4. **安装依赖**
   在虚拟环境中运行：

   ```bash
   pip install -r requirements.txt
   ```

---

### ② 运行 OCR 服务

1. 启动 FastAPI 服务：

   ```bash
   uvicorn ocr_service:app --host 0.0.0.0 --port 9000
   ```

   把ocr_service替换为baidu或者xfyun

2. 打开浏览器访问文档：

   ```
   http://127.0.0.1:9000/docs
   ```

   这里可以直接测试两个接口：
   - `/ocr/json`：通过图片路径传输
   - `/ocr/upload`：通过文件上传传输
