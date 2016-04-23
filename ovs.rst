
=================
Open vSwitch
=================

design of ovs
===============

flow caching
----------------

advanced use cases, such as network virtualization, result in long packet processing 
pipelines, and thus higher classification load than traditionally seen in virtual switches. 
To prevent Open vSwitch from consuming more hypervisor resources than competitive 
virtual switches, it was forced to implement flow caching.

The first packet of a flow results in a miss, and the kernel module directs the packet 
to the userspace component, which caches the forwarding decision for subsequent packets 
into the kernel.

In Open vSwitch, flow caching has greatly evolved over time; the initial datapath was a microflow cache,
essentially caching per transport connection forwarding decisions. In later versions, the datapath 
has two layers of caching: a microflow cache and a secondary layer, called a megaflow 
cache, which caches forwarding decisions for traffic aggregates beyond individual connections. 
