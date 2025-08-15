# Use NVIDIA CUDA runtime base image
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip python3-dev \
        build-essential git cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY requirements.txt ./
RUN pip3 install --upgrade pip && \
    pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118 && \
    pip3 install -r requirements.txt

# Copy project files
COPY . .

# Install the package in editable mode
RUN pip3 install -e .

# Build native extensions
RUN cd hy3dgen/texgen/custom_rasterizer && \
    python3 setup.py install && \
    cd ../differentiable_renderer && \
    python3 setup.py install && \
    cd /app

EXPOSE 8080

CMD ["python3", "api_server.py", "--host", "0.0.0.0", "--port", "8080"]
