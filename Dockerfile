# ZeroTier One plus a SOCKS5 endpoint for host-local Clash use.
# Based on the upstream containerized ZeroTier image layout.
FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i \
      -e 's|http://deb.debian.org/debian-security|https://mirrors.tuna.tsinghua.edu.cn/debian-security|g' \
      -e 's|http://deb.debian.org/debian|https://mirrors.tuna.tsinghua.edu.cn/debian|g' \
      /etc/apt/sources.list.d/debian.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl gnupg iproute2 microsocks \
    && install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL https://download.zerotier.com/contact%40zerotier.com.gpg \
       | gpg --dearmor -o /etc/apt/keyrings/zerotier.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/zerotier.gpg] https://download.zerotier.com/debian/bookworm bookworm main" \
       > /etc/apt/sources.list.d/zerotier.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends zerotier-one \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/zerotier-one
COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

VOLUME ["/var/lib/zerotier-one"]
EXPOSE 1080/tcp 9993/udp
ENTRYPOINT ["/entrypoint.sh"]
