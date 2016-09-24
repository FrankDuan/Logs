#!/usr/bin/env bash

cd /opt
rm -rf dragonflow
tar zxf dragonflow.tgz
#mv dev-dragonflow dragonflow
cp -r /opt/dragonflow/dragonflow/controller /usr/local/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/cmd /usr/local/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/neutron /usr/local/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/common /usr/local/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/db /usr/local/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/*.py /usr/local/lib/python2.7/dist-packages/dragonflow/
cp -r /opt/dragonflow/dragonflow/cli /usr/local/lib/python2.7/dist-packages/dragonflow/
