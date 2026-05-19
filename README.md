# 🔐 SecureSSH — Multi-Layer Ubuntu Authentication & Intrusion Detection Framework


[![License](https://img.shields.io/github/license/miky0020/secure-multilayer-auth-system?style=flat-square)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/miky0020/secure-multilayer-auth-system?style=flat-square&color=green)](https://github.com/miky0020/secure-multilayer-auth-system/commits/main)
[![Issues](https://img.shields.io/github/issues/miky0020/secure-multilayer-auth-system?style=flat-square&color=orange)](https://github.com/miky0020/secure-multilayer-auth-system/issues)
[![Stars](https://img.shields.io/github/stars/miky0020/secure-multilayer-auth-system?style=social)](https://github.com/miky0020/secure-multilayer-auth-system/stargazers)
[![Platform](https://img.shields.io/badge/platform-Ubuntu%2020.04%2B-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Python](https://img.shields.io/badge/python-3.8%2B-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Security Policy](https://img.shields.io/badge/security-policy-red?style=flat-square)](SECURITY.md)


## ⚡ Quick Start

```bash
git clone https://github.com/miky0020/secure-multilayer-auth-system.git
cd secure-multilayer-auth-system
cp .env.example .env && nano .env
sudo bash scripts/deploy.sh
sudo /usr/local/bin/ssh_dashboard.sh
```


A production-grade, defense-in-depth SSH security framework for Ubuntu servers. Combines cryptographic key enforcement, time-based two-factor authentication, intelligent brute-force mitigation, real-time alerting, and a live analytics dashboard into a single cohesive system.
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

![Architecture Diagram](screenshots/architecture.png)

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
Use console/VNC access. Temporarily comment out the PAM line:
```bash
# In /etc/pam.d/sshd, comment out this line:
# auth required pam_google_authenticator.so nullok

sudo systemctl reload sshd
```
Then re-enroll by running `google-authenticator` again as your user.

---

**Fail2Ban not banning IPs?**
Check that `logpath` matches your system's auth log location:
```bash
# Verify the log file exists
ls /var/log/auth.log

# Check Fail2Ban is reading it correctly
sudo fail2ban-client status sshd

# Restart after any config change
sudo systemctl restart fail2ban
```

---

**Telegram alerts not sending?**
```bash
# Step 1 — verify your bot token is valid
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getMe"

# Step 2 — verify your chat ID is correct
curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getUpdates"

# Step 3 — send a test alert manually
bash scripts/ssh_telegram_alert.sh "TEST" "admin" "127.0.0.1"
```
If Step 1 returns `{"ok":false}` your token is wrong. If Step 3 sends nothing, check your `TELEGRAM_CHAT_ID` in `.env`.

---

**SSH service won't reload?**
Always check for config syntax errors before reloading — a bad config can lock you out:
```bash
sudo sshd -t
```
Fix any errors reported, then reload:
```bash
sudo systemctl reload sshd
```

---

**Google Authenticator QR code lost?**
Re-run enrollment as the SSH user:
```bash
google-authenticator
```
This generates a new secret and QR code. Scan it in your Authenticator app and replace the old entry.

---

**Fail2Ban banning your own IP?**
Add your IP to the ignore list in `/etc/fail2ban/jail.local`:
```ini
[sshd]
ignoreip = 127.0.0.1/8 YOUR.IP.ADDRESS.HERE
```
Then restart:
```bash
sudo systemctl restart fail2ban
```
---
## Compatibility

| Ubuntu Version | Status |
|---|---|
| 20.04 LTS (Focal) | ✅ Verified |
| 22.04 LTS (Jammy) | ✅ Verified |
| 24.04 LTS (Noble) | ✅ Verified |
| 18.04 LTS (Bionic) | ⚠️ Partial |
---
## Roadmap

- [x] SSH key-only enforcement
- [x] Google Authenticator TOTP via PAM
- [x] Fail2Ban adaptive banning
- [x] Telegram real-time alerts
- [x] JSON login logger + terminal dashboard
- [ ] GeoIP country blocking (v2.0)
- [ ] Web dashboard via Flask (v2.0)
- [ ] Slack / Discord alert support (planned)
- [ ] Ansible deployment playbook (planned)
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
---
⭐ If this project helped you, consider giving it a star!
---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
> **Disclaimer:** Always test security changes in a non-production environment first, and maintain out-of-band access before modifying SSH configuration on a remote server.
