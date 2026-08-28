#!/bin/bash

docker network create rede-loja

docker volume create volume-banco

docker run -d \
  --name container-mysql \
  --network rede-loja \
  --memory="128m" \
  --cpus="0.2" \
  -v volume-banco:/var/lib/mysql \
  -v $(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=loja \
  mysql:latest
  
docker build -t imagem-node-api .

docker run -d \
  --name container-node \
  --network rede-loja \
  --memory="128m" \
  --cpus="0.2" \
  -p 3000:3000 \
  imagem-node-api
