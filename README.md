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

1. Create your sing-box configuration in JSON format (see [sing-box documentation](https://sing-box.sagernet.org/configuration/))
2. Encode it to base64
3. Provide the encoded string to the app

To encode your configuration:

```bash
# Linux/macOS
echo '{"your":"config"}' | base64

# Or use online tools for base64 encoding
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
