# OpenApp

[![Build Android](https://github.com/Open-Application/OpenApp/workflows/build-android/badge.svg)](https://github.com/Open-Application/OpenApp/actions?query=workflow:build-android)
[![Build iOS](https://github.com/Open-Application/OpenApp/workflows/build-apple/badge.svg)](https://github.com/Open-Application/OpenApp/actions?query=workflow:build-apple)
[![Build Windows](https://github.com/Open-Application/OpenApp/workflows/build-windows/badge.svg)](https://github.com/Open-Application/OpenApp/actions?query=workflow:build-windows)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/Open-Application/OpenApp?label=Version)](https://github.com/Open-Application/OpenApp/releases)
[![Code Size](https://img.shields.io/github/languages/code-size/Open-Application/OpenApp)](https://github.com/Open-Application/OpenApp)
[![Open Issues](https://img.shields.io/github/issues/Open-Application/OpenApp)](https://github.com/Open-Application/OpenApp/issues)

> An educational network security application designed to help users understand network security concepts, privacy protection technologies, and secure network communications.

Multi-platform: `iOS`, `macOS`, `Android`, `Windows`

## Features

- Educational network security tool
- Local-only processing 
- no data collection
- Privacy-first design
- Cross-platform support
- Open source with MIT License
- Supports sing-box configuration with base64 encoding

## Configuration

OpenApp accepts base64 encoded sing-box configuration. You can provide your configuration in base64 encoded format.

1. Create your sing-box configuration in JSON format (see [sing-box documentation](https://sing-box.sagernet.org/configuration/))
2. Encode it to base64
3. Provide the encoded string to the app

To encode your configuration:

```bash
# Linux/macOS
echo '{"your":"config"}' | base64

# Or use online tools for base64 encoding
```

For sample of a local test config, 

```json
{
    "log": {
        "timestamp": false,
        "level": "error"
    },
    "experimental": {
        "cache_file": {
            "enabled": true,
            "store_rdrc": true
        }
    },
    "dns": {
        "servers": [
            {
                "tag": "local",
                "type": "udp",
                "server": "119.29.29.29"
            },
            {
                "tag": "system",
                "type": "udp",
                "server": "8.8.8.8"
            }
        ],
        "rules": [
            {
                "action": "route-options",
                "domain": [
                    "*"
                ],
                "rewrite_ttl": 60,
                "udp_connect": false,
                "udp_disable_domain_unmapping": false
            }
        ],
        "strategy": "ipv4_only",
        "final": "local",
        "reverse_mapping": true,
        "disable_cache": false,
        "disable_expire": false
    },
    "inbounds": [
        {
            "type": "tun",
            "tag": "tun-in",
            "interface_name": "tun0",
            "address": [
                "172.19.0.0/30",
                "fdfe:dcba:9876::0/126"
            ],
            "mtu": 1500,
            "auto_route": true,
            "strict_route": true,
            "stack": "gvisor"
        }
    ],
    "outbounds": [
        {
            "tag": "direct-out",
            "type": "direct",
            "udp_fragment": true
        },
        {
            "tag": "block-out",
            "type": "block"
        }
    ],
    "route": {
        "final": "direct-out",
        "auto_detect_interface": true,
        "default_domain_resolver": {
            "server": "local",
            "rewrite_ttl": 60
        },
        "rules": [
            {
                "inbound": "tun-in",
                "action": "sniff"
            },
            {
                "protocol": "dns",
                "action": "hijack-dns"
            },
            {
                "protocol": ["quic", "BitTorrent"],
                "action": "reject"
            },
            {
                "ip_is_private": true,
                "outbound": "direct-out"
            },
            {
                "ip_cidr": [
                    "0.0.0.0/8",
                    "10.0.0.0/8",
                    "127.0.0.0/8",
                    "169.254.0.0/16",
                    "172.16.0.0/12",
                    "192.168.0.0/16",
                    "224.0.0.0/4",
                    "240.0.0.0/4"
                ],
                "outbound": "direct-out"
            },
            {
                "domain_suffix": [".local", ".localhost"],
                "outbound": "direct-out"
            }
        ]
    }
}
```

And the corresponding base64 encoded string,
```txt
ewogICAgImxvZyI6IHsKICAgICAgICAidGltZXN0YW1wIjogZmFsc2UsCiAgICAgICAgImxldmVsIjogImVycm9yIgogICAgfSwKICAgICJleHBlcmltZW50YWwiOiB7CiAgICAgICAgImNhY2hlX2ZpbGUiOiB7CiAgICAgICAgICAgICJlbmFibGVkIjogdHJ1ZSwKICAgICAgICAgICAgInN0b3JlX3JkcmMiOiB0cnVlCiAgICAgICAgfQogICAgfSwKICAgICJkbnMiOiB7CiAgICAgICAgInNlcnZlcnMiOiBbCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJ0YWciOiAibG9jYWwiLAogICAgICAgICAgICAgICAgInR5cGUiOiAidWRwIiwKICAgICAgICAgICAgICAgICJzZXJ2ZXIiOiAiMTE5LjI5LjI5LjI5IgogICAgICAgICAgICB9LAogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAidGFnIjogInN5c3RlbSIsCiAgICAgICAgICAgICAgICAidHlwZSI6ICJ1ZHAiLAogICAgICAgICAgICAgICAgInNlcnZlciI6ICI4LjguOC44IgogICAgICAgICAgICB9CiAgICAgICAgXSwKICAgICAgICAicnVsZXMiOiBbCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJhY3Rpb24iOiAicm91dGUtb3B0aW9ucyIsCiAgICAgICAgICAgICAgICAiZG9tYWluIjogWwogICAgICAgICAgICAgICAgICAgICIqIgogICAgICAgICAgICAgICAgXSwKICAgICAgICAgICAgICAgICJyZXdyaXRlX3R0bCI6IDYwLAogICAgICAgICAgICAgICAgInVkcF9jb25uZWN0IjogZmFsc2UsCiAgICAgICAgICAgICAgICAidWRwX2Rpc2FibGVfZG9tYWluX3VubWFwcGluZyI6IGZhbHNlCiAgICAgICAgICAgIH0KICAgICAgICBdLAogICAgICAgICJzdHJhdGVneSI6ICJpcHY0X29ubHkiLAogICAgICAgICJmaW5hbCI6ICJsb2NhbCIsCiAgICAgICAgInJldmVyc2VfbWFwcGluZyI6IHRydWUsCiAgICAgICAgImRpc2FibGVfY2FjaGUiOiBmYWxzZSwKICAgICAgICAiZGlzYWJsZV9leHBpcmUiOiBmYWxzZQogICAgfSwKICAgICJpbmJvdW5kcyI6IFsKICAgICAgICB7CiAgICAgICAgICAgICJ0eXBlIjogInR1biIsCiAgICAgICAgICAgICJ0YWciOiAidHVuLWluIiwKICAgICAgICAgICAgImludGVyZmFjZV9uYW1lIjogInR1bjAiLAogICAgICAgICAgICAiYWRkcmVzcyI6IFsKICAgICAgICAgICAgICAgICIxNzIuMTkuMC4wLzMwIiwKICAgICAgICAgICAgICAgICJmZGZlOmRjYmE6OTg3Njo6MC8xMjYiCiAgICAgICAgICAgIF0sCiAgICAgICAgICAgICJtdHUiOiAxNTAwLAogICAgICAgICAgICAiYXV0b19yb3V0ZSI6IHRydWUsCiAgICAgICAgICAgICJzdHJpY3Rfcm91dGUiOiB0cnVlLAogICAgICAgICAgICAic3RhY2siOiAiZ3Zpc29yIgogICAgICAgIH0KICAgIF0sCiAgICAib3V0Ym91bmRzIjogWwogICAgICAgIHsKICAgICAgICAgICAgInRhZyI6ICJkaXJlY3Qtb3V0IiwKICAgICAgICAgICAgInR5cGUiOiAiZGlyZWN0IiwKICAgICAgICAgICAgInVkcF9mcmFnbWVudCI6IHRydWUKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgInRhZyI6ICJibG9jay1vdXQiLAogICAgICAgICAgICAidHlwZSI6ICJibG9jayIKICAgICAgICB9CiAgICBdLAogICAgInJvdXRlIjogewogICAgICAgICJmaW5hbCI6ICJkaXJlY3Qtb3V0IiwKICAgICAgICAiYXV0b19kZXRlY3RfaW50ZXJmYWNlIjogdHJ1ZSwKICAgICAgICAiZGVmYXVsdF9kb21haW5fcmVzb2x2ZXIiOiB7CiAgICAgICAgICAgICJzZXJ2ZXIiOiAibG9jYWwiLAogICAgICAgICAgICAicmV3cml0ZV90dGwiOiA2MAogICAgICAgIH0sCiAgICAgICAgInJ1bGVzIjogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAiaW5ib3VuZCI6ICJ0dW4taW4iLAogICAgICAgICAgICAgICAgImFjdGlvbiI6ICJzbmlmZiIKICAgICAgICAgICAgfSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgInByb3RvY29sIjogImRucyIsCiAgICAgICAgICAgICAgICAiYWN0aW9uIjogImhpamFjay1kbnMiCiAgICAgICAgICAgIH0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJwcm90b2NvbCI6IFsicXVpYyIsICJCaXRUb3JyZW50Il0sCiAgICAgICAgICAgICAgICAiYWN0aW9uIjogInJlamVjdCIKICAgICAgICAgICAgfSwKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgImlwX2lzX3ByaXZhdGUiOiB0cnVlLAogICAgICAgICAgICAgICAgIm91dGJvdW5kIjogImRpcmVjdC1vdXQiCiAgICAgICAgICAgIH0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJpcF9jaWRyIjogWwogICAgICAgICAgICAgICAgICAgICIwLjAuMC4wLzgiLAogICAgICAgICAgICAgICAgICAgICIxMC4wLjAuMC84IiwKICAgICAgICAgICAgICAgICAgICAiMTI3LjAuMC4wLzgiLAogICAgICAgICAgICAgICAgICAgICIxNjkuMjU0LjAuMC8xNiIsCiAgICAgICAgICAgICAgICAgICAgIjE3Mi4xNi4wLjAvMTIiLAogICAgICAgICAgICAgICAgICAgICIxOTIuMTY4LjAuMC8xNiIsCiAgICAgICAgICAgICAgICAgICAgIjIyNC4wLjAuMC80IiwKICAgICAgICAgICAgICAgICAgICAiMjQwLjAuMC4wLzQiCiAgICAgICAgICAgICAgICBdLAogICAgICAgICAgICAgICAgIm91dGJvdW5kIjogImRpcmVjdC1vdXQiCiAgICAgICAgICAgIH0sCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgICJkb21haW5fc3VmZml4IjogWyIubG9jYWwiLCAiLmxvY2FsaG9zdCJdLAogICAgICAgICAgICAgICAgIm91dGJvdW5kIjogImRpcmVjdC1vdXQiCiAgICAgICAgICAgIH0KICAgICAgICBdCiAgICB9Cn0KCg==
```

For more details on sing-box configuration, refer to the official [sing-box documentation](https://sing-box.sagernet.org/).

## Privacy

OpenApp operates entirely locally on your device:
- **No data collection** - We do not collect any personal information
- **No tracking** - No analytics or telemetry
- **No third-party services** - All operations are local
- **Transparent** - Open source codebase

See our [Privacy Policy](assets/legals/privacy_policy.txt) and [Terms of Use](assets/legals/user_agreement.txt) for details.

## License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

Copyright (c) 2025 Root-Corporation PTY LTD Australia

## Contact

- GitHub: https://github.com/Open-Application/OpenApp
- Email: developer@root-corporation.com

## Credits

- [WireGuard](https://www.wireguard.com/) - Fast and modern VPN protocol
- [VLESS](https://github.com/XTLS/Xray-core) - Lightweight protocol
- [Trojan](https://trojan-gfw.github.io/trojan/) - Unidentifiable mechanism
- [Hysteria2](https://v2.hysteria.network/) - Feature-packed proxy & relay protocol
- [SagerNet/sing-box](https://github.com/SagerNet/sing-box) - Universal proxy platform

## Disclaimer

This software is provided for educational and research purposes only. Users are responsible for ensuring their use complies with all applicable laws and regulations.
