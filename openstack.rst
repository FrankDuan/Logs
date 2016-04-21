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

* neutron net-create net1

* neutron subnet-create net1 192.168.12.0/24


create vm
---------------
nova boot --image cirros-0.3.4-x86_64-uec --flavor 1 --nic net-id=4b12d425-4fe2-47ad-8ffe-a95522d8f12c vm1


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
^^^^^^^^^^^^^^^^^^^^
/usr/bin/python -m pdb /usr/local/bin/neutron-server --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini

