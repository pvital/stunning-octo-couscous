FROM public.ecr.aws/docker/library/python:3.15.0a4

# Pre-requirement to build confluent-kafka in it's latest version
RUN mkdir -p /etc/apt/keyrings
RUN wget -qO - https://packages.confluent.io/deb/8.1/archive.key \
    | gpg --dearmor -o /etc/apt/keyrings/confluent.gpg

COPY ./confluent-platform.sources /etc/apt/sources.list.d/confluent-platform.sources

# System update and requirements installation.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        librdkafka-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV WORKDIR_=/root/base
WORKDIR $WORKDIR_

COPY ./requirements.txt .

ENV VIRTUAL_ENV="$WORKDIR_/venv"
RUN python -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

RUN python -m pip install --upgrade pip \
    && python -m pip install -r requirements.txt