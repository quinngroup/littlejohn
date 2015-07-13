docker run -d \
    --net="host" \
    -p 31000-31050:31000-31050 \
    -e "MESOS_MASTER=zk://1.1.1.1:2181/mesos" \
    -v /sys:/sys -v /var/run/docker.sock:/var/run/docker.sock \
    magsol/lj-mesos-slave
