
=====================================
Dragonflow and distributed controller
=====================================

Dragonflow
===================

FAQ
---------------------


+++ 
gem install redis 无法连接

1. gem sources -l
2. gem sources --remove old_urs --add new_url

+++
redis-trib.rb create --replicas 1 10.249.28.249:4001 10.249.28.249:4002 10.249.28.249:4003 10.249.28.249:4004 10.249.28.249:4005 10.249.28.249:4006 failed
`require': cannot load such file -- redis 

1. gem install redis
2. add sudo before the ruby command

devstack config
^^^^^^^^^^^^^^^^^^^^
DF_SELECTIVE_TOPO_DIST=True
DF_REDIS_PUBSUB=True
enable_plugin dragonflow http://git.openstack.org/openstack/dragonflow
#enable_service df-etcd
#enable_service df-etcd-server
enable_service df-redis
enable_service df-redis-server
enable_service df-redis-publisher-service
enable_service df-controller
enable_service df-ext-services

disable_service n-net
enable_service q-svc
enable_service q-l3
disable_service heat
disable_service tempest
NEUTRON_CREATE_INITIAL_NETWORKS=False

CI devstack config
^^^^^^^^^^^^^^^^^^^^
* [df]

* remote_db_ip 10.220.2.75

* remote_db_port 4001  

* remote_db_hosts 10.220.2.75:4001 

* nb_db_class dragonflow.db.drivers.etcd_db_driver.EtcdDbDriver

* local_ip 10.220.2.75            

* tunnel_type geneve         

* apps_list l2_app.L2App,l3_proactive_app.L3ProactiveApp,dhcp_app.DHCPApp,dnat_app.DNATApp,sg_app.SGApp  

* monitor_table_poll_time 30               

* enable_df_pub_sub True              

* pub_sub_use_multiproc True    

* publishers_ips 127.0.0.1

* enable_selective_topology_distribution True 

* pub_sub_driver zmq_pubsub_driver 

* pub_sub_multiproc_driver zmq_pubsub_multiproc_driver 

* [df_dnat_app]

* external_network_bridge br-ex   

* int_peer_patch_port patch-ex     

* ex_peer_patch_port patch-int 

* [df_l2_app] 

* l2_responder True  

OVN
=========================

* HV 与 HV 之间的流量，只能用 Geneve 和 STT 两种. 虽然 VXLAN 是数据中心常用的 tunnel 技术，但是 VXLAN header 是固定的，只能传递一个 VNID（VXLAN network identifier），如果想在 tunnel 里面传递更多的信息，VXLAN 实现不了。所以 OVN 选择了 Geneve 和 STT，Geneve 的头部有个 option 字段，支持 TLV 格式，用户可以根据自己的需要进行扩展，而 STT 的头部可以传递 64-bit 的数据，比 VXLAN 的 24-bit 大很多。 OVN tunnel 封装时使用了三种数据，Logical datapath identifier, 类似Tunnel ID，Logical input port identifier，Logical output port identifier.

