FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    g++ \
    gcc \
    git \
    libbz2-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libssl-dev \
    make \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN git clone --depth 1 https://github.com/ANGSD/angsd.git /tmp/angsd
WORKDIR /tmp/angsd
RUN make

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libbz2-1.0 \
    libcurl4 \
    liblzma5 \
    libstdc++6 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/angsd/angsd /usr/local/bin/angsd

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'set -e' \
    'if [ "${1:-}" = "angsd" ]; then shift; fi' \
    'if [ "${1:-}" = "--help" ]; then exec /usr/local/bin/angsd; fi' \
    'exec /usr/local/bin/angsd "$@"' \
    > /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--help"]
