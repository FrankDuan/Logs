=======================
Openstack
=======================

use cases
==============

ebay
--------------

* 4100台服务器

* 自建的openstack

* paypal主要还在用vmware

devstack
============

mysql
--------------

* mysql -u root -p

* stackdb

* use neutron


Frequently used commands
========================

create network
---------------

* openstack network create net1

openstack subnet create --network net1 --subnet-range 192.168.12.0/24 subnet1
* neutron router-create router1
* neutron router-interface-add router1 subnet1
* neutron router-update router1 --route destination=10.10.10.0/24,nexthop=192.168.12.254

* neutron net-create ext-net --router:external True
* neutron subnet-create ext-net --name ext-subnet --allocation-pool start=203.0.113.101,end=203.0.113.200 \
  --disable-dhcp --gateway 203.0.113.1 203.0.113.0/24
* neutron router-gateway-set --disable-snat router1 ext-net

glance image-create --name "cirros" --file ./cirros-0.3.4-x86_64-disk.img  --disk-format qcow2 --container-format bare --progress

create vm
---------------
openstack server create --image cirros --flavor 0 --nic net-id=8588c407-fe3c-4f97-af5f-8e772e6193ad vm4

openstack flavor create --public m1.extra_tiny --id 0 --ram 256 --disk 0 --vcpus 1 --rxtx-factor 1

Neutron Inside
================

L3 agent
----------------

L3RpcCallback
^^^^^^^^^^^^^^^
defines Rpc that will be called by L3 Plugin?


python
================

debug python 
----------------
/usr/bin/python -m pdb /usr/local/bin/neutron-server --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini

b /opt/stack/neutron/neutron/api/v2/router.py:74
