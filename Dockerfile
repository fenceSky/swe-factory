# Dockerfile Usage
# Build:
#   docker build --network=host -t swe-factory:0.1 .
# Run:
#   docker run -d \
#       -v /var/run/docker.sock:/var/run/docker.sock \
#       -v /usr/bin/docker:/usr/bin/docker \
#       -v /root/github_cache:/root/swe-factory/testbed \
#       -e OPENAI_API_BASE_URL="<your_base_url>" \
#       -e OPENAI_KEY="<your_sk>" \
#       -e MODEL="claude-sonnet-4-20250514" \
#       -e BENCH_DIR="data_collection/collect/swe-mini" \
#       -e PROCESS_NUM="1" \
#       -e ROUND_LIMIT="1" \
#       -e REPO_CACHE_DIR="testbed" \
#       -e OUTPUT_DIR="output" \
#       -e TEMPERATURE="0.2" \
#       --name swe-test swe-factory:0.1

# use aliyun linux
# FROM alibaba-cloud-linux-3-registry.cn-hangzhou.cr.aliyuncs.com/alinux3/alinux3:latest
FROM docker.io/library/centos:7

ARG USER_ROOT=/root
ARG CONDA_ROOT=$USER_ROOT/miniconda3
ARG SWE_ENV_NAME=swe-factory
ARG SWE_ROOT=$USER_ROOT/swe-factory

ENV TZ=Asia/Shanghai
ENV PATH=$CONDA_ROOT/envs/$SWE_ENV_NAME/bin:$CONDA_ROOT/bin:$PATH
ENV PYTHONPATH=.:$PYTHONPATH

# prepare system
# RUN yum install -y gcc gcc-c++ procps-ng tzdata wget which unzip tree git && \
#     ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install miniconda
WORKDIR $CONDA_ROOT
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
#     bash miniconda.sh -b -u -p . && rm -f miniconda.sh && \
#     conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
#     conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# install python
RUN conda create --name $SWE_ENV_NAME 'python==3.12.5' -y

# install swe-factory
COPY . $SWE_ROOT
WORKDIR $SWE_ROOT
RUN pip install -r requirements.txt
