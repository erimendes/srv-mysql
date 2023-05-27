#!/bin/bash

docker compose up -d

container_bdm1="bdm1"
container_bdm2="bdm2"

while ! docker exec $container_bdm1 mysqladmin ping -uroot -p"senha" --silent; do
    sleep 1
done

echo "O MySQL dentro do contêiner $container_bdm1 está em execução."

while ! docker exec $container_bdm2 mysqladmin ping -uroot -p"senha" --silent; do
    sleep 1
done

echo "O MySQL dentro do contêiner $container_bdm2 está em execução."

sh ini-replication.sh
