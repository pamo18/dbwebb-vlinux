FROM debian:stretch-slim

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y jq

WORKDIR /client

COPY bthloggen.bash server.txt ./

ENTRYPOINT bash /client/bthloggen.bash --help && /bin/bash

RUN ["bash"]
RUN chmod +x /client/*.bash
