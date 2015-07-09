docker run -d \
    -p 8080:8080 \
    magsol/lj-marathon --master zk://1.1.1.1:2181,2.2.2.2:2181/mesos --zk zk://1.1.1.1:2181,2.2.2.2:2181/marathon
