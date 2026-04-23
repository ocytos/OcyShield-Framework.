#!/bin/bash

# --- Colors ---
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' 

echo -e "${BLUE}[*] OcyShield Framework - Installing...${NC}"

# 1. Check for root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[!] Please run as root (use sudo)${NC}"
  exit 1
fi

# 2. Check for dependencies (Git & Python)
for cmd in git python3 pip3; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}[!] Error: $cmd is not installed.${NC}"
        exit 1
    fi
done

# 3. Cleanup & Clone
if [ -d "/opt/ocyshield" ]; then
    echo -e "${BLUE}[*] Updating previous version...${NC}"
    rm -rf /opt/ocyshield
fi

echo -e "${BLUE}[*] Cloning repository to /opt/ocyshield...${NC}"
git clone --quiet https://github.com/ocytos/OcyShield-Framework.git /opt/ocyshield

# 4. Install dependencies
echo -e "${BLUE}[*] Installing requirements...${NC}"
if [ -f "/opt/ocyshield/requirements.txt" ]; then
    # Usamos --break-system-packages para asegurar compatibilidad en Arch/Kali
    pip3 install -r /opt/ocyshield/requirements.txt --break-system-packages --quiet
fi

# 5. Fix permissions (Secure way)
echo -e "${BLUE}[*] Setting up permissions...${NC}"
chown -R root:root /opt/ocyshield
chmod -R 755 /opt/ocyshield

# 6. Create global command (More robust wrapper)
echo -e "${BLUE}[*] Creating global command 'ocysh'...${NC}"
cat <<EOF > /usr/local/bin/ocysh
#!/bin/bash
python3 /opt/ocyshield/main.py "\$@"
EOF
chmod +x /usr/local/bin/ocysh

echo -e "${GREEN}[+] OcyShield installed successfully! Type 'ocysh' to start.${NC}"
