FROM alpine:latest as builder

ARG VERSION=1.8.5
ARG ARCH=amd64
ARG STATIC=-static

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb-${VERSION}${STATIC}_linux_${ARCH}.tar.gz && \
    tar xvfz influxdb-${VERSION}${STATIC}_linux_${ARCH}.tar.gz && \
    rm -f influxdb-${VERSION}${STATIC}_linux_${ARCH}.tar.gz && \
    ([ -f influxdb-${VERSION}-1/influxd ] && cp influxdb-${VERSION}-1/influxd /root || cp influxdb-${VERSION}-1/usr/bin/influxd /root) && \
    rm -rf influxdb-${VERSION}-1

RUN wget https://raw.githubusercontent.com/influxdata/influxdb/v${VERSION}/LICENSE
RUN wget https://raw.githubusercontent.com/influxdata/influxdb/v${VERSION}/DEPENDENCIES.md && \
echo "" >> LICENSE && \
echo "" >> LICENSE && \
echo "--------------------------------------------------------------" >> LICENSE && \
echo "# Dependencies compiled into the binary as stated by InfluxDB" >> LICENSE && \
echo "" >> LICENSE && \
echo "" >> LICENSE && \
cat DEPENDENCIES.md >> LICENSE
RUN mv LICENSE influxdb-${VERSION}

FROM scratch as image
ARG VERSION=1.8.5
COPY --from=builder /root/influxd /
COPY --from=builder /influxdb-${VERSION} /licenses/influxdb-${VERSION}
ENTRYPOINT ["/influxd"]