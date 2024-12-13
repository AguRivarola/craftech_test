#!/bin/bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

cd /home/ubuntu/

# Nombre del archivo que se creará
SCRIPT_NAME="/home/ubuntu/docker-compose.yml"

# Contenido del nuevo script
cat << 'EOF' > $SCRIPT_NAME
version: '3.8'

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
    volumes:
      # - ./backend:/usr/src/app/
      - static:/src/app/static
      - static:/src/app/media
    ports:
      - 8000:8000
    env_file:
      - ./backend/.env
    depends_on:
      - db
  
  db:
    container_name: db
    image: postgres:12.0-alpine
    env_file: ./backend/.env.postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - 5432:5432

volumes:
  postgres_data:
  static:
  media:
EOF

chmod +x $SCRIPT_NAME

docker-compose -f $SCRIPT_NAME up -d
