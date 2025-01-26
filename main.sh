#!/bin/bash
echo "Kurulum sırasında herhangi bir hata mesajı için /var/log/syslog dosyasına bakabilirsiniz."
sleep 5

git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit

sudo apt-get update || exit 1
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || exit 1
sudo apt-get install -y ca-certificates curl gnupg || exit 1

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update || exit 1
sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
docker-compose --version

PID=$(sudo lsof -t -i :11434)
if sudo lsof -t -i :11434 >/dev/null; then
    echo "Port 11434'ü kullanan süreç bulunup durduruluyor."
    sudo kill -9 $PID || { echo "Süreç öldürülemedi!"; exit 1; }
else
    echo "Port 11434'ü kullanan bir süreç bulunamadı."
fi


echo "http://localhost:5678 bağlantısını kurulum başladıktan yaklaşık 5 dakika sonra kontrol ediniz"

docker compose --profile cpu up
