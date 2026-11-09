# ZeroTier SOCKS5 for Windows Docker Desktop + Clash

This adds a SOCKS5 listener to a ZeroTier One container. The listener is published only on host loopback at `127.0.0.1:21081`; it is intended for Clash running on the same Windows host. ZeroTier config/state persists in the `zerotier-one` Docker volume.

## Start

1. Copy `.env.example` to `.env` and replace the example with your ZeroTier 16-character network ID.
2. In this directory run `docker compose up -d --build`.
3. Approve the new node in ZeroTier Central.
4. Check it with `docker exec zerotier-socks5 zerotier-cli listnetworks`.
5. In Clash, add a SOCKS5 proxy at server `127.0.0.1`, port `21081`, then route only the desired ZeroTier destination IPs/CIDRs to it.

## Notes

- The proxy has no SOCKS authentication because the published port is restricted to host loopback. Do not change the host bind address to `0.0.0.0` unless you add authentication and firewall restrictions.
- This provides access to ZeroTier-routed destinations. It does not make all host traffic use ZeroTier; route only the selected destination IPs/CIDRs through this Clash proxy.
- Docker Desktop must expose `/dev/net/tun` to Linux containers. If startup reports it missing, this container cannot run in the current Docker Desktop backend/configuration.
- Inspect the container's route table with `docker exec zerotier-socks5 ip route`.
