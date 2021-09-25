FROM postgres:11-alpine

RUN apk add curl python3 bzip2 sqlite
RUN python3 -m ensurepip && pip3 install awscli --upgrade

COPY backup.sh /usr/local/bin/

ENTRYPOINT ["/bin/bash", "/usr/local/bin/backup.sh"]

