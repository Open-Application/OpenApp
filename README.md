# OpenApp

[![Build](https://github.com/Open-Application/OpenApp/workflows/build/badge.svg)](https://github.com/Open-Application/OpenApp/actions?query=workflow:build)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/Open-Application/OpenApp?label=Version)](https://github.com/Open-Application/OpenApp/releases)
[![Releases](https://img.shields.io/badge/Releases-Download-blue)](https://github.com/Open-Application/OpenApp/releases)
[![TestFlight](https://img.shields.io/badge/TestFlight-Test-blue)](https://testflight.apple.com/join/1mJPzBU6)

> Open-Source network research platform for privacy and security

Developed by Root Corporation PTY LTD Australia 🇦🇺

[![Access for iOS/macOS](./assets/badges/apple.svg)](https://bit.ly/OpenAppApple)
[![Get it on Google Play](./assets/badges/android.svg)](https://bit.ly/OpenAppGooglePlay)
---

## Overview

OpenApp is an enterprise-grade, open-source network research platform designed for educational institutions, security researchers, and privacy advocates. Developed and published by Root Corporation PTY LTD Australia.

**Multiple Support**
- iOS • macOS • Android • Windows
- ShadowTLS • VLESS • Trojan • Hysteria/Hysteria2 • TUIC • WireGuard • Naive • AnyTLS • Tailscale
- English • 中文 • हिन्दी • Bahasa Indonesia • Bahasa Melayu • Русский • Türkçe • العربية • فارسی

**Responsible Use**
- Users are responsible for ensuring their use complies with local laws and regulations
- Not designed for illegal activities or bypassing lawful restrictions

**IMPORTANT LEGAL NOTICE**

This software is provided **exclusively for educational and research purposes**.

---

## Key Features

### 📱 **Supported Platforms**

- iOS
- macOS
- Android
- Windows

### 🔌 **Supported Protocols**

- ShadowTLS
- VLESS
- Trojan
- Hysteria/Hysteria2
- TUIC
- WireGuard
- Naive
- AnyTLS
- Tailscale

### 🌏 **Supported Languages**

- English
- 中文 (Chinese)
- हिन्दी (Hindi)
- Bahasa Indonesia
- Bahasa Melayu
- Русский (Russian)
- Türkçe (Turkish)
- العربية (Arabic)
- فارسی (Persian/Farsi)


---

## Configuration

OpenApp supports industry-standard configuration format with secure base64 encoding for enhanced portability and security.

### Quick Start

1. **Prepare Configuration** - Create your OpenApp(`sing-box` compatible) configuration in JSON format ([see documentation](https://sing-box.sagernet.org/configuration/))
2. **Encode to Base64** - Convert your JSON configuration to base64 format
3. **Import to OpenApp** - Provide the encoded string through the app interface

### Encoding Your Configuration

```bash
# On Linux/macOS
echo '{"your":"config"}' | base64

# Or use any standard base64 encoding tool
```

### Sample Local Configuration

Below is a reference configuration for local testing and educational purposes: 

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

**Learn More:** Comprehensive configuration documentation available at [details](https://sing-box.sagernet.org/configuration/)

---

## Legals

**Legal Documents:**
- [Privacy Policy](assets/legals/privacy_policy.txt) - Comprehensive privacy commitments
- [Terms of Use](assets/legals/user_agreement.txt) - Usage guidelines and legal terms

### Open Source License

MIT license: [LICENSE](LICENSE)

### Disclaimer & Compliance

**⚠️ IMPORTANT LEGAL NOTICE**

This software is provided **exclusively for educational and research purposes**.

**User Responsibilities:**
- ✅ Ensure compliance with all applicable **Local laws and regulations**
- ✅ Use only for **legitimate educational or research activities**
- ✅ Respect all local, state, and federal legal requirements
- ❌ Not intended for any illegal activities or circumventing legal restrictions

**Availability:** OpenApp is developed and published by an Australian registered business entity.

**AS-IS Provision:** This software is provided "AS IS" without warranty of any kind, express or implied. The authors and copyright holders shall not be liable for any claims, damages, or other liabilities arising from the use of this software.

---

## Contact & Support

**Root-Corporation PTY LTD Australia**

- **GitHub Repository:** https://github.com/Open-Application/OpenApp
- **Developer Email:** developer@root-corporation.com
- **Issues & Bug Reports:** [GitHub Issues](https://github.com/Open-Application/OpenApp/issues)

---

## Credits

- [ShadowTLS](https://github.com/ihciah/shadow-tls)
- [VLESS](https://github.com/XTLS/Xray-core)
- [Trojan](https://github.com/trojan-gfw/trojan)
- [Hysteria](https://github.com/apernet/hysteria)
- [TUIC](https://github.com/tuic-protocol/tuic)
- [WireGuard](https://github.com/WireGuard)
- [Naive](https://github.com/klzgrad/naiveproxy)
- [AnyTLS](https://github.com/anytls/anytls-go)
- [Tailscale](https://github.com/tailscale/tailscale)
- [sing-box](https://github.com/SagerNet/sing-box)

---

<details>
<summary>Made with ❤️</summary>
<details>
<summary>Developed in Australia 🇦🇺</summary>
</details>
</details>
