#!/bin/bash

# Создаём нужные папки
mkdir -p /ComfyUI/models/checkpoints
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae

# Устанавливаем huggingface_hub
pip install -q huggingface_hub

# Передаём HF_TOKEN
export HF_TOKEN=${HF_TOKEN}

echo "========================================="
echo "📥 Скачиваем лёгкие модели LTX-2.3 (distilled)"
echo "   Репозиторий: raderos/Light-comfyui-models-ltx"
echo "========================================="

# Скачиваем всё одним вызовом
python3 -c "
from huggingface_hub import snapshot_download
import os

snapshot_download(
    repo_id='raderos/Light-comfyui-models-ltx',
    local_dir='/ComfyUI/models',
    token=os.environ.get('HF_TOKEN', '')
)
"

echo "✅ Все модели скачаны!"
echo "🚀 Запускаем ComfyUI..."

python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188 --disable-smart-memory
