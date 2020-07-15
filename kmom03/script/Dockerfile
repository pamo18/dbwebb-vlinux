FROM debian:stretch-slim

WORKDIR .

COPY commands.bash /kmom03/

RUN apt-get update && \
    apt-get -y install nano \
    telnet \
    bsdmainutils

ENTRYPOINT bash /kmom03/commands.bash all && /bin/bash

RUN chmod +x /kmom03/*.bash
