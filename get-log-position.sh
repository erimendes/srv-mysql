#!/bin/bash

echo "Get the log position and name"
master1_result=$(docker exec bdm1 mysql -u root --password=senha --execute="SHOW MASTER STATUS;")
master1_log=$(echo $master1_result|awk '{print $6}')
master1_position=$(echo $master1_result|awk '{print $7}')

master2_result=$(docker exec bdm2 mysql -u root --password=senha --execute="show master status \g")
master2_log=$(echo $master2_result|awk '{print $6}')
master2_position=$(echo $master2_result|awk '{print $7}')

echo $master1_log
echo $master1_position

echo $master2_log
echo $master2_position


IP_BDM1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bdm1)
IP_BDM2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bdm2)
# Connect slave to master.
docker exec bdm2 \
   mysql -u root --password=senha \
   --execute="stop slave; \
   reset slave; \
CHANGE REPLICATION SOURCE TO SOURCE_HOST='$IP_BDM1', SOURCE_LOG_FILE='$master1_log', SOURCE_LOG_POS=$master1_position, SOURCE_SSL=1;
START REPLICA USER='repl' PASSWORD='secret';
SHOW REPLICA STATUS \G"

docker exec bdm1 \
   mysql -u root --password=senha \
   --execute="stop slave;\
   reset slave;\
CHANGE REPLICATION SOURCE TO SOURCE_HOST='$IP_BDM2', SOURCE_LOG_FILE='$master2_log', SOURCE_LOG_POS=$master2_position, SOURCE_SSL=1;
START REPLICA USER='repl' PASSWORD='secret';
SHOW REPLICA STATUS \G"

      sleep 2
        echo
        echo ###################        SECOND status

        docker exec bdm2 \
                        mysql -u root --password=senha \
                        --execute="SHOW SLAVE STATUS\G;"

        sleep2
        echo
        echo ###################        FIRST status

        docker exec bdm1 \
                        mysql -u root --password=senha \
                        --execute="SHOW SLAVE STATUS\G;"
