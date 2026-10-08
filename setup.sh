#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}=== Обновление системы и установка Docker ===${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl docker.io docker-compose-v2

echo -e "${GREEN}=== Создание директории для VPN ===${NC}"
mkdir -p ~/amneziawg && cd ~/amneziawg

echo -e "${GREEN}=== Создание конфигурации docker-compose.yml ===${NC}"
cat <<EOF > docker-compose.yml
services:
  amneziawg:
    image: amneziawg/amneziawg-easy:latest
    container_name: amneziawg
    volumes:
      - ./config:/etc/amneziawg
    ports:
      - "51820:51820/udp"
    environment:
      - WG_HOST=$(curl -s ifconfig.me)
    restart: always
    cap_add:
      - NET_ADMIN
EOF

echo -e "${GREEN}=== Запуск VPN-сервера ===${NC}"
sudo docker compose up -d

echo -e "${GREEN}=== Готово! ===${NC}"
echo -e "Конфигурация для Windows создана."
echo -e "Чтобы увидеть ее код, выполните команду: cat ~/amneziawg/config/peer1.conf"

