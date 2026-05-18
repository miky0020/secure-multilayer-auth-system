# 🔐 SecureSSH — Multi-Layer Ubuntu Authentication & Intrusion Detection Framework

A production-grade, defense-in-depth SSH security framework for Ubuntu servers.

---

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Scripts Reference](#scripts-reference)
- [Security Layers Explained](#security-layers-explained)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)

---

## Overview

SecureSSH is a comprehensive, layered security framework for Ubuntu server administrators. It addresses password-based brute force, credential stuffing, and unauthorized access through multiple independent but complementary security controls.
---

## Features

| Feature | Description |
|---|---|
| **SSH Hardening** | Enforces public-key-only authentication, disables root login, restricts cipher suites |
| **Google Authenticator 2FA** | TOTP-based two-factor authentication via PAM integration |
| **Fail2Ban Protection** | Adaptive brute-force blocking with configurable ban thresholds |
| **Telegram Real-Time Alerts** | Instant push notifications on every login attempt |
| **Python Login Event Logger** | Structured, timestamped JSON logging of all SSH login events |
| **Terminal Analytics Dashboard** | Live, color-coded shell dashboard showing login history and threat summary |

---
## System Architecture

![Architecture Diagram](architecture.png)

---

## Prerequisites

- Ubuntu 20.04 LTS or later (22.04/24.04 recommended)
- `sudo` / root access
- A configured SSH key pair (RSA 4096-bit or Ed25519)
- A smartphone with Google Authenticator (iOS / Android)
- A Telegram bot token and chat ID
- Python 3.8+
---

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/miky0020/Seceure-ssh-2fa-project.git
cd Seceure-ssh-2fa-project
```

### 2. Install System Dependencies
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    openssh-server \
    libpam-google-authenticator \
    fail2ban \
    python3 \
    python3-pip \
    curl \
    ufw
```

### 3. Deploy Scripts
```bash
sudo cp scripts/ssh_dashboard.sh /usr/local/bin/
sudo cp scripts/ssh_telegram_alert.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/ssh_dashboard.sh
sudo chmod +x /usr/local/bin/ssh_telegram_alert.sh
sudo python3 scripts/ssh_logger.py
```

> ⚠️ **Warning:** Ensure you have console or out-of-band access before modifying SSH configuration on a remote server.
---

Paste this next section:

```
---

## Configuration

### SSH Hardening (`/etc/ssh/sshd_config`)
```
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
MaxAuthTries 2
LoginGraceTime 20
MaxSessions 5
X11Forwarding no
AllowTcpForwarding no
PermitUserEnvironment no
```

### Fail2Ban (`/etc/fail2ban/jail.local`)
```
[sshd]
enabled  = true
port     = ssh
maxretry = 2
bantime  = 3600
findtime = 600
```

### Telegram Alerts
```
export TELEGRAM_BOT_TOKEN="your_bot_token_here"
export TELEGRAM_CHAT_ID="your_chat_id_here"
```
```


---

## Scripts Reference

### `scripts/ssh_dashboard.sh` — Terminal Analytics Dashboard
```bash
sudo /usr/local/bin/ssh_dashboard.sh
```
Displays recent logins, failed attempts, banned IPs, and top source IPs.

### `scripts/ssh_logger.py` — Structured Login Event Logger

| Field | Description |
|---|---|
| `timestamp` | ISO 8601 UTC timestamp |
| `event_type` | LOGIN_SUCCESS, LOGIN_FAILED, DISCONNECT |
| `username` | Authenticated or attempted username |
| `source_ip` | Client IP address |
| `auth_method` | publickey, password, keyboard-interactive |

```bash
sudo python3 scripts/ssh_logger.py
```
### `scripts/ssh_telegram_alert.sh` — Real-Time Telegram Notifications
```bash
# Test alert manually
bash scripts/ssh_telegram_alert.sh "TEST" "admin" "192.168.1.1"
```
---

## Security Layers Explained

| Threat | Mitigated By |
|---|---|
| Password brute force | SSH hardening (`PasswordAuthentication no`) |
| SSH key theft | Google Authenticator 2FA |
| Credential stuffing | Fail2Ban + key-only auth |
| Undetected intrusion | `ssh_logger.py` + Telegram alerts |
| Lateral movement | `AllowTcpForwarding no`, session limits |

---

## Usage

```bash
# Check Fail2Ban status
sudo fail2ban-client status sshd

# Unban an IP
sudo fail2ban-client set sshd unbanip <IP_ADDRESS>

# View live login log
tail -f /var/log/ssh_events.json | python3 -m json.tool

# Launch analytics dashboard
sudo /usr/local/bin/ssh_dashboard.sh
```

---

## Troubleshooting

**Locked out after enabling 2FA?**
Use console/VNC access. Temporarily comment out `pam_google_authenticator.so` in `/etc/pam.d/sshd`, then re-enroll.

**Fail2Ban not banning IPs?**
Check that `logpath` in `jail.local` matches your system's auth log location (`/var/log/auth.log`).

**Telegram alerts not sending?**
```bash
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getMe"
```

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'feat: description'`
4. Push to your fork: `git push origin feature/your-feature-name`
5. Open a Pull Request

---

## Author

**Mikhaynu Marma** — [@miky0020](https://github.com/miky0020)

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
> **Disclaimer:** Always test security changes in a non-production environment first, and maintain out-of-band access before modifying SSH configuration on a remote server.
