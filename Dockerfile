FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Set the working directory
WORKDIR /otif

ARG DEBIAN_FRONTEND=noninteractive

# Install Conda
RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
    && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r \
    && conda install -y python=3 \
    && conda update conda -y \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH

# Install dependencies
RUN apt-get -qq update -y && \
    apt-get -qq -y install --no-install-recommends \
    build-essential \
    git \
    golang \
    ffmpeg \
    make && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

ENV PYTHONPATH="/otif/python:${PYTHONPATH}"