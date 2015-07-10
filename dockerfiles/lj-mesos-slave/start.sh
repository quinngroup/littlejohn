docker run -d \
    --net="host" \
    -p 31000-31050:31000-31050 \
    -e "MESOS_MASTER=zk://1.1.1.1:2181/mesos" \
    magsol/lj-mesos-slave
