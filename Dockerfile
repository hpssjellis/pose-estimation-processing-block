# syntax = docker/dockerfile:experimental
FROM python:3.7.5-stretch

WORKDIR /app

RUN apt update && apt install -y ffmpeg libsm6 libxext6

# Python dependencies
COPY requirements-blocks.txt ./
RUN pip3 --no-cache-dir install -r requirements-blocks.txt

# We may need a specific TensorFlow version depending on our architecture
COPY install_tensorflow.sh ./install_tensorflow.sh
RUN ./install_tensorflow.sh && \
    rm install_tensorflow.sh

COPY third_party /third_party
COPY . ./

EXPOSE 4446

CMD python3 -u dsp-server.py
