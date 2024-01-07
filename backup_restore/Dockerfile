FROM postgres:11-alpine

RUN apk add --no-cache curl python3 bzip2 sqlite aws-cli

COPY backup.sh /usr/local/bin/

ENTRYPOINT ["/bin/bash", "/usr/local/bin/backup.sh"]

