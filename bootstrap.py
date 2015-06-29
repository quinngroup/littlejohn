import argparse
import os
import socket
import subprocess as sp

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = 'LittleJohn Bootstrapper',
        epilog = 'lol moar bitz', add_help = 'How to use',
        prog = 'python littlejohn_setup.py <args>')
    parser.add_argument("-s", "--slaves", required = True,
        help = "Path to a text file containing the list of slaves.")
    parser.add_argument("-m", "--master", required = True,
        help = "Name of the Mesos master node.")
    parser.add_argument("-n", "--namenode", required = True,
        help = "Name of the Hadoop NameNode.")

    args = vars(parser.parse_args())
    if os.path.exists("BUILD"):
        # Remove and start over.
        os.rmdir("BUILD")
    if not os.path.exists("BUILD"):
        sp.call(["mkdir", "-p", "BUILD/configuration"])

    # Get a handle on all the hosts we're dealing with.
    slaves = [line.strip() for line in file(args['slaves'])]
    nodes = slaves
    if args['master'] not in nodes:
        nodes.append(args['master'])
    if args['namenode'] not in nodes:
        nodes.append(args['namenode'])
    fqdn_nodes = [socket.getfqdn(n) for n in nodes]
    ip_nodes = [socket.gethostbyname(n) for n in fqdn_nodes]

    # Step 1: Copy the baremetal script into the BUILD directory.
    sp.call(["cp", "0-baremetal.sh BUILD/"])

    # Step 2: Build the hosts file and copy over the needed bash scripts.
    hosts = """# Sample hosts file, pilfered yet again from Ubuntu 14.04.2.

127.0.0.1\tlocalhost
%s

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters"""
    lines = ['%s\t%s\t\t%s' % (ip, dn.split(".")[0], dn) for ip, dn in zip(ip_nodes, fqdn_nodes)]
    hosts = hosts % "\n".join(lines)
    os.mkdir("BUILD/configuration/etc")
    f = open("BUILD/configuration/etc/hosts", "w")
    f.write(hosts)
    f.close()
    sp.call(["cp", "templates/bashrc.sh", "BUILD/configuration/"])

    # Step 3: Configure Hadoop.
    hadoop_dir = "BUILD/configuration/hadoop/etc/hadoop"
    sp.call(["mkdir", "-p", hadoop_dir])
    sp.call(["cp", "templates/hadoop/etc/hadoop/hdfs-site.xml", hadoop_dir])
    sp.call(["cp", "templates/hadoop/etc/hadoop/container-executor.cfg", hadoop_dir])
    sp.call(["cp", "templates/hadoop/etc/hadoop/hadoop-env.sh", hadoop_dir])
    f = open("%s/slaves" % hadoop_dir, "w")  # Slaves file.
    f.write("\n".join(slaves))
    f.close()
    f = open("templates/hadoop/etc/hadoop/core-site.xml", "r")
    coresite = f.read()
    f.close()
    f = open("%s/core-site.xml" % hadoop_dir, "w")  # core-site.xml
    f.write(coresite.replace("HADOOP_NAMENODE_HERE", args['namenode']))
    f.close()
    f = open("templates/hadoop/etc/hadoop/mapred-site.xml", "r")
    coresite = f.read()
    f.close()
    f = open("%s/mapred-site.xml" % hadoop_dir, "w")  # mapred-site.xml
    f.write(coresite.replace("HADOOP_NAMENODE_HERE", args['namenode']))
    f.close()

    # Step 4: Configure Spark.
    spark_dir = "BUILD/configuration/spark/conf"
    sp.call(["mkdir", "-p", spark_dir])
    sp.call(["cp", "templates/spark/conf/docker.properties", spark_dir])
    sp.call(["cp", "templates/spark/conf/metrics.properties", spark_dir])
    sp.call(["cp", "templates/spark/conf/spark-env.sh", spark_dir])
    f = open("%s/slaves" % spark_dir, "w")  # Slaves file.
    f.write("\n".join(slaves))
    f.close()
    f = open("templates/spark/conf/spark-defaults.conf", "r")
    defaults = f.read()
    f.close()
    f = open("%s/spark-defaults.conf" % spark_dir, "w")  # spark-defaults.conf
    f.write(defaults.replace("HADOOP_NAMENODE_HERE", args['namenode'])
        .replace("MESOS_MASTER_HERE", args['master']))
    f.close()

    # Step 5: Configure Mesos.
    mesos_dir = "BUILD/configuration/mesos/var/mesos/deploy"
    sp.call(["mkdir", "-p", mesos_dir])
    sp.call(["cp", "templates/mesos/var/mesos/deploy/mesos-deploy-env.sh", mesos_dir])
    sp.call(["cp", "templates/mesos/var/mesos/deploy/mesos-master-env.sh", mesos_dir])
    f = open("%s/slaves" % mesos_dir, "w")  # Slaves file.
    f.write("\n".join(slaves))
    f.close()
    f = open("%s/masters" % mesos_dir, "w")  # Masters file.
    f.write("%s\n" % args['master'])
    f.close()
    f = open("templates/mesos/var/mesos/deploy/mesos-slave-env.sh", "r")
    mesosslave = f.read()
    f.close()
    f = open("%s/mesos-slave-env.sh" % mesos_dir, "w")
    f.write(mesosslave.replace("MESOS_MASTER_HERE", args['master']))
    f.close()

    # All done!
    print "All finished!"
    print "Next step: transfer the BUILD/ directory and its contents to all " \
        "the nodes in your cluster. Effectively for each node, you'll need to " \
        "run three commands: \n"
    print "1: scp -r BUILD/ user@node:~/"
    print "2: ssh user@node"
    print "3: cd BUILD && sudo ./0-baremetal.sh\n"
    print "Once it's finished, you should be able to delete the BUILD/ directory."






