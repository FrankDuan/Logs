=======================
OpenNetVM
=======================

Environment Setup
=================

VM setup
--------------
1. ssh 192.168.56.101
2. sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) code /home/duan/host

Attention: dpdk can not be placed on vboxsf

Startup OpenNetVM
-----------------
1. cd /home/duan/host/openNetVM
2. ./scripts/setup_environment.sh 
3. ./onvm/go.sh 0,1,2 1 -s stdout
4. ryu-manager --verbose --observe-links ryu/app/gui_topology/gui_topology.py
5. ./examples/flow_table/go.sh 0,1 4
