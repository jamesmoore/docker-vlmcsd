FROM alpine:latest as builder
WORKDIR /root
RUN apk add --no-cache git make build-base && \
    git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git && \
    cd vlmcsd && \
    make

FROM alpine:latest
COPY --from=builder /root/vlmcsd/bin/vlmcsd /vlmcsd
COPY --from=builder /root/vlmcsd/etc/vlmcsd.kmd /vlmcsd.kmd
RUN apk add --no-cache tzdata

EXPOSE 1688/tcp

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD nc -z localhost 1688 || exit 1

CMD ["/vlmcsd", "-D", "-d", "-t", "3", "-e", "-v"]

