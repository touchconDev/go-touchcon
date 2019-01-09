FROM alpine:3.5

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/Touchcon/go-touchconcoin && \
  (cd go-ethereum && make gtc) && \
  cp go-ethereum/build/bin/gtc /gtc && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-ethereum && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gtc"]
