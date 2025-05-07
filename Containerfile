FROM public.ecr.aws/docker/library/python:3.14.0a7

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV WORKDIR_=/root/repo

WORKDIR $WORKDIR_
COPY ./requirements.txt .

ENV VIRTUAL_ENV="$WORKDIR_/.venv"
RUN python -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python -m pip install --upgrade pip \
    && python -m pip install -r requirements.txt