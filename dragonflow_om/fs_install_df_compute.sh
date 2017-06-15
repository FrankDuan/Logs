#!/bin/bash

rm -rf dragonflow
tar zxf dragonflow.tgz
chown openstack:openstack dragonflow -R
chmod 755 dragonflow 

rm /opt/dragonflow/usr/lib/python2.7/site-packages/dragonflow -r
cp -rp dragonflow /opt/dragonflow/usr/lib/python2.7/site-packages/

pid=$(ps -ef|grep "/usr/bin/python /opt/dragonflow/usr/bin/df-local-controller"|grep -v grep|awk '{print $2}')

echo old pid is $pid
kill $pid
