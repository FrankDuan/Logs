#!/usr/bin/env bash


DEST=/opt
STACK_USER=root

#local_host="`hostname --fqdn`"
#local_ip=`host $local_host 2>/dev/null | awk '{print $NF}'`

REMOTE_DB_IP=10.249.28.249
REMOTE_DB_PORT=4001

source /opt/function.sh
source /opt/dragonflow/devstack/redis_driver	   

#wget http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz -O $DEST/redis/redis-$REDIS_VERSION.tar.gz
#wget https://cache.ruby-lang.org/pub/ruby/$RUBY_VERSION/ruby-$RUBY_VERSION.0.tar.gz -O $DEST/ruby/ruby-$RUBY_VERSION.0.tar.gz


#nb_db_driver_install_server
#sudo gem source -r https://rubygems.org/
#sudo gem sources -a http://rnd-mirrors.huawei.com/rubygems/
#sudo gem install redis
configure_redis
nb_db_driver_start_server
