FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Установка зависимостей
RUN pip3 install --upgrade pip && \
    pip3 install kornia==0.7.3 \
    imageio-ffmpeg \
    matplotlib \
    opencv-python-headless \
    sqlalchemy \
    gdown

# Клонирование ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && \
    pip3 install -r requirements.txt

# Установка кастомных нод
RUN cd /ComfyUI/custom_nodes && \
    # ComfyUI-LTXVideo
    git clone https://github.com/kijai/ComfyUI-LTXVideo && \
    cd ComfyUI-LTXVideo && pip3 install -r requirements.txt && cd .. && \
    # ComfyUI-KJNodes
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    cd ComfyUI-KJNodes && pip3 install -r requirements.txt && cd .. && \
    # ComfyUI-VideoHelperSuite
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite && \
    cd ComfyUI-VideoHelperSuite && pip3 install -r requirements.txt && cd .. && \
    # comfyui_controlnet_aux (опционально, но есть в вашем JSON)
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    cd comfyui_controlnet_aux && pip3 install -r requirements.txt && cd .. && \
    # rgthree-comfy
    git clone https://github.com/rgthree/rgthree-comfy && \
    # ComfyUI-GGUF
    git clone https://github.com/city96/ComfyUI-GGUF && \
    cd ComfyUI-GGUF && pip3 install -r requirements.txt && cd .. && \
    # ComfyUI-MelBandRoFormer
    git clone https://github.com/kijai/ComfyUI-MelBandRoFormer && \
    cd ComfyUI-MelBandRoFormer && pip3 install -r requirements.txt

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
