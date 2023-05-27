#!/bin/bash

echo "Waiting for MySQL to start..."
export IP_ADDR=${DOCKER0_IP:-$(ip a show dev docker0 |grep inet|awk '{print $2}'|awk -F\/ '{print $1}')}
echo $IP_ADDR

IP_BDM1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bdm1)
IP_BDM2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bdm2)
echo $IP_BDM1
echo $IP_BDM2
echo "Create user on master database"
        docker exec bdm1 \
                        mysql -u root --password='senha' \
                        --execute="create user 'repl'@'$IP_BDM2' identified by 'secret';\
                        grant replication slave on *.* to 'repl'@'$IP_BDM2';\
                        flush privileges;"

        docker exec bdm2 \
                        mysql -u root --password='senha' \
                        --execute="create user 'repl'@'$IP_BDM1' identified by 'secret';\
                        grant replication slave on *.* to 'repl'@'$IP_BDM1';\
                        flush privileges;"


        echo "Get the log position and name"
        master1_result=$(docker exec bdm1 mysql -u root --password=senha --execute="SHOW MASTER STATUS;")
        master1_log=$(echo $master1_result|awk '{print $6}')
        master1_position=$(echo $master1_result|awk '{print $7}')


        master2_result=$(docker exec bdm2 mysql -u root --password=senha --execute="SHOW MASTER STATUS;")
        master2_log=$(echo $master2_result|awk '{print $6}')
        master2_position=$(echo $master2_result|awk '{print $7}')

        echo $master1_log
        echo $master1_position

        echo $master2_log
        echo $master2_position

sleep 2
echo "Configurar log e position"

sh get-log-position.sh
