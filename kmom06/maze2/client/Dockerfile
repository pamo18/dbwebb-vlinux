FROM debian:stretch-slim

RUN apt-get update && \
    apt-get install -y curl

WORKDIR /client

COPY mazerunner.bash ./

ENTRYPOINT bash /client/mazerunner.bash loop && /bin/bash

RUN ["bash"]
RUN chmod +x /client/*.bash
