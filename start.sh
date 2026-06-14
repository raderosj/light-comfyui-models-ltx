#!/bin/bash

# Создаём нужные папки
mkdir -p /ComfyUI/models/checkpoints
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae

# Устанавливаем huggingface_hub
pip install -q huggingface_hub

# Передаём HF_TOKEN
export HF_TOKEN=${HF_TOKEN}

# ==========================================
# ОПТИМИЗАЦИИ ПАМЯТИ ДЛЯ LTX-2.3
# ==========================================

# 1. Ключевая переменная для PyTorch (решает проблему фрагментации памяти)
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

# 2. Отключаем кэширование CUDA (экономит немного памяти)
export CUDA_CACHE_DISABLE=1

# 3. Для Hugging Face (ускоряет загрузку моделей)
export HF_HUB_ENABLE_HF_TRANSFER=0

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

# ==========================================
# ОПТИМИЗИРОВАННЫЙ ЗАПУСК COMFYUI
# ==========================================
echo "🚀 Запускаем ComfyUI с оптимизациями памяти..."

python3 /ComfyUI/main.py \
    --listen 0.0.0.0 \
    --port 8188 \
    --lowvram \
    --disable-smart-memory \
    --reserve-vram 2 \
    --use-pytorch-cross-attention
