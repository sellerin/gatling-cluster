FROM eu.gcr.io/iron-inkwell-205415/perf:latest

RUN apt-get update && \
    apt-get install -y curl jq zip

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]