#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}[*] OcyShield Framework - Installing...${NC}"

# Si la carpeta no existe, la clonamos en /opt
if [ ! -d "/opt/ocyshield" ]; then
    echo -e "${RED}[*] Cloning repository to /opt/ocyshield...${NC}"
    sudo git clone https://github.com/ocytos/OcyShield-Framework.git /opt/ocyshield
fi

# Creamos el comando global
echo -e "#!/bin/bash\ncd /opt/ocyshield && python3 main.py \"\$@\"" | sudo tee /usr/local/bin/ocysh > /dev/null
sudo chmod +x /usr/local/bin/ocysh

# Instalamos dependencias
echo -e "${RED}[*] Installing dependencies...${NC}"
sudo pip3 install -r /opt/ocyshield/requirements.txt --quiet

echo -e "${RED}[+] Installation finished! Type 'ocysh' to start.${NC}"
