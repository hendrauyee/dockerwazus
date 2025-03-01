#!/bin/bash
set -e

echo "============================================"
echo "Memperbarui sistem dan menginstal dependensi"
echo "============================================"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git apt-transport-https ca-certificates gnupg2

echo ""
echo "============================================"
echo "Memeriksa dan menginstal Docker"
echo "============================================"
if ! command -v docker &> /dev/null; then
    echo "Docker belum terinstal. Menginstal Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
else
    echo "Docker sudah terinstal."
fi

echo ""
echo "============================================"
echo "Memeriksa dan menginstal Docker Compose plugin"
echo "============================================"
if ! docker compose version &> /dev/null; then
    echo "Docker Compose plugin belum terinstal. Menginstal..."
    sudo apt install -y docker-compose-plugin
else
    echo "Docker Compose plugin sudah terinstal."
fi

echo ""
echo "============================================"
echo "Meng-clone repository Wazuh Docker dan checkout ke tag v4.11.0"
echo "============================================"
sudo mkdir -p /opt/wazuh-docker
cd /opt/wazuh-docker

# Clone repository jika belum ada
if [ ! -d ".git" ]; then
    echo "Meng-clone repository Wazuh Docker..."
    sudo git clone https://github.com/wazuh/wazuh-docker.git .
fi

echo "Mengambil semua tag dan checkout ke v4.11.0..."
sudo git fetch --all --tags
sudo git checkout tags/v4.11.0 -b v4.11.0

echo ""
echo "============================================"
echo "Masuk ke direktori deployment single-node"
echo "============================================"
cd single-node

# Opsional: Hasilkan sertifikat SSL (jika diperlukan)
echo ""
echo "============================================"
echo "Menghasilkan sertifikat SSL (jika diperlukan)"
echo "============================================"
# Jika sertifikat belum ada, generate certs dengan perintah di bawah.
# Catatan: Pastikan folder config akan terisi dengan sertifikat yang diperlukan.
sudo docker compose -f generate-certs.yml up -d --build || echo "Generate sertifikat gagal atau sertifikat sudah tersedia, lanjutkan..."

echo ""
echo "============================================"
echo "Menarik image Wazuh (manager, dashboard, indexer)"
echo "============================================"
sudo docker compose pull

echo ""
echo "============================================"
echo "Menjalankan container Wazuh"
echo "============================================"
sudo docker compose up -d

echo ""
echo "============================================"
echo "Instalasi selesai!"
echo "============================================"
echo "Untuk memeriksa container, jalankan: sudo docker ps -a"
echo "Akses Wazuh Dashboard melalui: https://<IP_SERVER_Anda>"
echo "Catatan: Browser akan menampilkan peringatan karena sertifikat self-signed."
