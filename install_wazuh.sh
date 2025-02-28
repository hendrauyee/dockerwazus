#!/bin/bash
set -e

echo "Memperbarui sistem..."
sudo apt update && sudo apt upgrade -y

echo "Menginstal dependensi..."
sudo apt install -y curl git apt-transport-https ca-certificates gnupg2

# Install Docker jika belum terpasang
if ! command -v docker &>/dev/null; then
  echo "Docker tidak ditemukan. Menginstal Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  rm get-docker.sh
else
  echo "Docker sudah terinstal."
fi

# Install Docker Compose plugin jika belum terpasang
if ! docker compose version &>/dev/null; then
  echo "Docker Compose tidak ditemukan. Menginstal Docker Compose..."
  sudo apt install -y docker-compose-plugin
else
  echo "Docker Compose sudah terinstal."
fi

# Buat folder untuk Wazuh Docker dan clone repository resmi
echo "Meng-clone repository Wazuh Docker..."
sudo mkdir -p /opt/wazuh-docker
cd /opt/wazuh-docker
sudo git clone https://github.com/wazuh/wazuh-docker.git . || echo "Repository sudah ada, melewati cloning."

# Masuk ke folder single-node (deployment yang disarankan)
cd single-node

# (Opsional) Jika muncul peringatan tentang atribut "version" pada docker-compose.yml,
# Anda dapat mengabaikannya karena hanya peringatan.

echo "Menarik image terbaru dan menjalankan container Wazuh..."
sudo docker compose pull
sudo docker compose up -d

echo "Instalasi selesai. Cek status container dengan:"
echo "  sudo docker ps -a"
echo "Akses dashboard melalui: https://<IP_SERVER_DEBIAN>"
