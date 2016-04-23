
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
