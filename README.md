# srv-mysql

version: '3'

services:
  master:
    image: mysql:latest
    container_name: master
    command: --server-id=1 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --def>    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: senha
    volumes:
      - ./master-data:/var/lib/mysql

  slave:
    image: mysql:latest
    container_name: slave
    command: --server-id=2 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --def>    depends_on:
      - master
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: senha
    volumes:
      - ./slave-data:/var/lib/mysql

command: --server-id=1 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password
command: --server-id=2 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password
