FROM --platform=linux/amd64 alpine:3.15 as builder

ARG VERSION=2.1.1
ARG ARCH=amd64

RUN apk update && apk add curl
RUN curl https://dl.influxdata.com/influxdb/releases/influxdb2-${VERSION}-linux-${ARCH}.tar.gz -o influxdb2-${VERSION}-linux-${ARCH}.tar.gz  && \
    tar xvfz influxdb2-${VERSION}-linux-${ARCH}.tar.gz && \
    rm -f influxdb2-${VERSION}-linux-${ARCH}.tar.gz && \
    ([ -f influxdb2-${VERSION}-linux-${ARCH}/influxd ] && cp influxdb2-${VERSION}-linux-${ARCH}/influxd /root || cp influxdb2-${VERSION}-linux-${ARCH}/usr/bin/influxd /root) && \
    rm -rf influxdb2-${VERSION}-linux-${ARCH}

RUN curl https://raw.githubusercontent.com/influxdata/influxdb/v${VERSION}/LICENSE -o LICENSE && \
echo "" >> LICENSE && \
echo "" >> LICENSE && \
echo "--------------------------------------------------------------" >> LICENSE && \
echo "# Dependencies compiled into the binary as stated by InfluxDB" >> LICENSE && \
echo "" >> LICENSE && \
echo "" >> LICENSE
RUN mv LICENSE influxdb-${VERSION}
RUN mkdir -p /root/tmp && cp /root/influxd /root/tmp && mkdir /root/tmp/.influxdbv2 && chown -R 65534:65534 /root/tmp 

FROM scratch as image
ARG VERSION=2.1.1
USER 65534:65534
COPY --from=builder /root/tmp/ /
COPY --from=builder /influxdb-${VERSION} /licenses/influxdb-${VERSION}
ENTRYPOINT ["/influxd"]