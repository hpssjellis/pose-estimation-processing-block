# syntax = docker/dockerfile:experimental
## FROM ubuntu:20.04
FROM gitpod/workspace-full:latest

USER root


WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y curl wget ffmpeg libsm6 libxext6 zlib1g-dev python3.8 libpython3.8 python3.8-distutils

# Install pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.8 get-pip.py "pip==21.3.1"

# We may need a specific TensorFlow version depending on our architecture
COPY install_tensorflow.sh ./install_tensorflow.sh
RUN ./install_tensorflow.sh && \
    rm install_tensorflow.sh

# Other Python dependencies
COPY requirements-blocks.txt ./
RUN pip3.8 --no-cache-dir install -r requirements-blocks.txt

# Rest of the app
COPY . ./

EXPOSE 4449

CMD python3.8 -u dsp-server.py
