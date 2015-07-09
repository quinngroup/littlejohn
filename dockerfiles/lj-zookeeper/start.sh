docker run -d \
    --net="host" \
    -p 2181:2181 \
    -e SERVER_ID=1 \
    -e ADDITIONAL_ZOOKEEPER_1=server.1=1.1.1.1:2888:3888 \
    -e ADDITIONAL_ZOOKEEPER_2=server.2=2.2.2.2:2888:3888 \
    magsol/lj-zookeeper
