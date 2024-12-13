#!/bin/bash
sudo apt-get update
sudo apt-get install ca-certificates curl
echo "packetes instalados" >> /home/ubuntu/set_up.log
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker y compose instalado" >> /home/ubuntu/set_up.log

cd /home/ubuntu/

# Nombre del archivo que se creará
SCRIPT_NAME="/home/ubuntu/docker-compose.yml"

# Contenido del nuevo script
cat << 'EOF' > $SCRIPT_NAME
services:
 
  react:
    container_name: react
    image: bondiolino/craf_test:frontend
    ports:
      - 3000:3000
    environment:
      - CHOKIDAR_USEPOLLING=true

  api:
    image: bondiolino/craf_test:backend
    ports:
      - 8000:8000
    environment:
      - DATABASE=postgres
      - SQL_DATABASE=postgres
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=core
      - SQL_PORT=5432
      - SQL_HOST=db
    depends_on:
      - db
  
  db:
    container_name: db
    image: postgres:12.0-alpine
    environment:
      - DATABASE=postgres
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=core
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - 5432:5432

volumes:
  postgres_data:
EOF
echo "Compose file creado" >> /home/ubuntu/set_up.log
chmod +x $SCRIPT_NAME
echo "Esperando daemon de docker" >> /home/ubuntu/set_up.log

sleep 15

echo "Termino de esperar daemon de docker" >> /home/ubuntu/set_up.log

sudo docker compose -f $SCRIPT_NAME up -d
echo "Corrido el 'sudo docker-compose -f $SCRIPT_NAME up -d' " >> /home/ubuntu/set_up.log

sudo docker pull bondiolino/craf_test:nginx
sudo docker run -dp 80:80 --name nginx bondiolino/craf_test:nginx


cat << 'EOF' > /home/ubuntu/deploy_ngx.sh
sudo docker pull bondiolino/craf_test:nginx
sudo docker stop nginx
sudo docker rm nginx
sudo docker run -dp 80:80 --name nginx bondiolino/craf_test:nginx
EOF