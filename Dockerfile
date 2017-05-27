FROM alpine:3.5
MAINTAINER barwell

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

ENV GOPATH /go
RUN apk add --update -t .build-deps libc-dev go git make \
    && mkdir /logs \
    && git clone https://github.com/google/mtail.git $GOPATH/src/github.com/google/mtail \
    && cd $GOPATH/src/github.com/google/mtail \
    && git reset --hard 1683324c7f5a8352456eab12376dd3c4100ef44d \
    && make \
    && cp $GOPATH/bin/mtail /bin/mtail \
    && apk del --purge .build-deps \
    && rm -rf /go /var/cache/apk/*

COPY s6/etc /etc
COPY progs /etc/mtail

EXPOSE 9253

ENTRYPOINT [ "/init" ]
