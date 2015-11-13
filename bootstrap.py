import argparse
import os
import shutil
import socket
import stat
import subprocess as sp

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = 'LittleJohn Bootstrapper',
        epilog = 'lol moar bitz', add_help = 'How to use',
        prog = 'python bootstrap.py <args>')
    parser.add_argument("-s", "--slaves", required = True,
        help = "Path to a text file containing the list of slaves.")
    parser.add_argument("-n", "--namenode", required = True,
        help = "Name of the Hadoop NameNode.")
    parser.add_argument("-u", "--user", required = True,
        help = "Username to use to SCP/SSH into the masters and workers.")

    args = vars(parser.parse_args())
    if os.path.exists("BUILD"):
        # Remove and start over.
        shutil.rmtree("BUILD")
    if not os.path.exists("BUILD"):
        sp.call(["mkdir", "-p", "BUILD/configuration"])

    # Get a handle on all the hosts we're dealing with.
    slaves = [line.strip() for line in file(args['slaves'])]
    nodes = slaves[:]
    if args['namenode'] not in nodes:
        nodes.append(args['namenode'])
    fqdn_nodes = [socket.getfqdn(n) for n in nodes]
    ip_nodes = [socket.gethostbyname(n) for n in fqdn_nodes]

    # Step 1: Copy the baremetal script into the BUILD directory.
    sp.call(["cp", "0-baremetal.sh", "BUILD/"])

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

    # Last step: create a bash script that will initialize everything on every client.
    u = args['user']
    f = open("initialize.sh", "w")
    f.write("#!/bin/bash\n")
    for n in fqdn_nodes:
        # SCP.
        f.write("scp -r BUILD/ %s@%s:~/\n" % (u, n))

        # Pipe the commands through SSH.
        f.write("ssh -t %s@%s \"cd BUILD; sudo ./0-baremetal.sh; cd ..; rm -rf BUILD/\"\n" % (u, n))
    f.close()
    st = os.stat("initialize.sh")
    os.chmod("initialize.sh", st.st_mode | stat.S_IEXEC)

    # All done!
    print "All finished!"
    print "Next step: run the auto-generated \"initialize.sh\" script, which " + \
        "will perform the necessary installs across all your machines."






