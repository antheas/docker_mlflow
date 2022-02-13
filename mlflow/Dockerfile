FROM python:3.10

COPY requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt

RUN mkdir -p /.ssh /workspace && ln -s /workspace/known_hosts /.ssh/known_hosts

RUN mkdir -p /root/.ssh && ln -s /workspace/known_hosts /root/.ssh/known_hosts