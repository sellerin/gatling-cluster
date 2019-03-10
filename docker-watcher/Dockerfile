FROM eu.gcr.io/iron-inkwell-205415/perf:latest

RUN apk add --update \
    curl jq bash \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]