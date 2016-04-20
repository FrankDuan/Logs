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
