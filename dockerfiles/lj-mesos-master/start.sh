docker run -d \
    --net="host" \
    -p 5050:5050 \
    -e "MESOS_HOSTNAME=1.1.1.1" \
    -e "MESOS_IP=1.1.1.1" \
    -e "MESOS_ZK=zk://1.1.1.1:2181/mesos" \
    magsol/lj-mesos-master
