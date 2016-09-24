#!/usr/bin/env bash

cd /opt
rm -rf dragonflow
tar zxf dragonflow.tgz
rm -rf /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/drivers/dragonflow
mkdir /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/drivers/dragonflow
cp /opt/dragonflow/dragonflow/neutron/ml2/*.py /usr/lib/python2.7/dist-packages/neutron/plugins/ml2/drivers/dragonflow/
cp -r /opt/dragonflow/dragonflow/neutron /usr/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/common /usr/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/db /usr/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/*.py /usr/lib/python2.7/dist-packages/dragonflow/
