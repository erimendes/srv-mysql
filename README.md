# srv-mysql

version: '3'

services:
  master:
    image: mysql:latest
    container_name: master
    command: --server-id=1 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password  
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: senha
    volumes:
      - ./master-data:/var/lib/mysql

  slave:
    image: mysql:latest
    container_name: slave
    command: --server-id=2 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password
    depends_on:
      - master
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: senha
    volumes:
      - ./slave-data:/var/lib/mysql

command: --server-id=1 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password
command: --server-id=2 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password



command: --server-id=2 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password

command: --server-id=1 --log-bin=mysql-bin --binlog-format=row --gtid-mode=ON --enforce-gtid-consistency=true --default-authentication-plugin=mysql_native_password

SHOW MASTER STATUS \G
CREATE USER 'repl'@'192.168.0.4' IDENTIFIED BY 'secret';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.0.4';
SHOW MASTER STATUS \G
File:  mysql-bin.000003
         Position: 720

SHOW SLAVE STATUS \G
CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.0.3', SOURCE_LOG_FILE='mysql-bin.000003', SOURCE_LOG_POS=720, SOURCE_SSL=1;
START REPLICA USER='repl' PASSWORD='secret';
SHOW REPLICA STATUS \G


CONFIGURAR O SLAVE COMO MASTER

Esta parte deu certo:
SHOW MASTER STATUS \G
CREATE USER 'repl'@'192.168.0.3' IDENTIFIED BY 'secret';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.168.0.3';
SHOW MASTER STATUS \G
File:  mysql-bin.000003
         Position: 720

SHOW SLAVE STATUS \G
CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.0.4', SOURCE_LOG_FILE='mysql-bin.000003', SOURCE_LOG_POS=720, SOURCE_SSL=1;
START REPLICA USER='repl' PASSWORD='secret';
SHOW REPLICA STATUS \G
