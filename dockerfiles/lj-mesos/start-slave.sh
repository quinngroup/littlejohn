docker run -d \
    --net="host" \
    --entrypoint="mesos-slave" \
    -p 31000-31050:31000-31050 \
    -e "MESOS_MASTER=zk://1.1.1.1:2181,2.2.2.2:2181/mesos" \
    magsol/lj-mesos
