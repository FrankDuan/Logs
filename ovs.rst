
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

Packet Classification
---------------------

packet classification in the context of OpenFlow is especially costly because of the generality of 
the form of the match, which may test any combination of Ethernet addresses, IPv4 and IPv6 addresses,
TCP and UDP ports, and many other fields, including packet metadata such as the switch ingress port.

Open vSwitch uses a tuple space search classifier [34] for all of its packet classification, both kernel and
userspace. To understand how tuple space search works, assume that all the flows in an Open vSwitch flow 
table matched on the same fields in the same way, e.g., all flows match the source and destination 
Ethernet address but no other fields. A tuple search classifier implements such a flow table 
as a single hash table. If the controller then adds new flows with a different form of match, the
classifier creates a second hash table that hashes on the fields matched in those flows. 
(The tuple of a hash table in a tuple space search classifier is, properly, the set of
fields that form that hash table’s key, but we often refer to the hash table itself as the tuple, 
as a kind of useful shorthand.) With two hash tables, a search must look in both hash tables. If 
there are no matches, the flow table doesn’t contain a match; if there is a match in one hash
table, that flow is the result; if there is a match in both, then the result is the flow with 
the higher priority. As the controller continues to add more flows with new forms of
match, the classifier similarly expands to include a hash table for each unique match, 
and a search of the classifier must look in every hash table.

