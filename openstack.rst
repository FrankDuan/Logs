+++
create network

neutron net-create net1
neutron subnet-create net1 192.168.12.0/24

++++
create vm

nova boot --image cirros-0.3.4-x86_64-uec --flavor 1 --nic net-id=4b12d425-4fe2-47ad-8ffe-a95522d8f12c vm1
