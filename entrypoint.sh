#!/bin/sh
set -eu

if [ ! -e /dev/net/tun ]; then
  echo 'FATAL: /dev/net/tun is missing; ZeroTier cannot start.' >&2
  exit 1
fi

/usr/sbin/zerotier-one -d

if [ -n "${ZT_NETWORK_ID:-}" ]; then
  tries=0
  until /usr/sbin/zerotier-cli info >/dev/null 2>&1; do
    tries=$((tries + 1))
    if [ "$tries" -ge 30 ]; then
      echo 'FATAL: ZeroTier service did not become ready.' >&2
      exit 1
    fi
    sleep 1
  done
  /usr/sbin/zerotier-cli join "$ZT_NETWORK_ID"
fi

exec /usr/bin/microsocks -i 0.0.0.0 -p 1080
