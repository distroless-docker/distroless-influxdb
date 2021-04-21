# Description

This InfluxDB container utilizes the officially statically linked pre-built binaries from InfluxDB.
The image is built upon docker scratch without any further dependencies.

# Usage

```sh
docker run -p 8086:8086 -v $(pwd)/influxdata:/.influxdb distroless/distroless-influxdb:latest
```

# Licenses
This image itself is published under the `CC0 license`.

This image also contains:
- InfluxDB which is licensed under the `MIT license`.

However, this image might also contain other software(parts) which may be under other licenses (such as OpenSSL or other dependencies). Some licenses are automatically collected and exported to the /licenses folder within the container. It is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.