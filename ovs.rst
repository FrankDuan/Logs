
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

microflow cache
^^^^^^^^^^^^^^^^^
 a single cache entry exact matches with all the packet header fields supported
by OpenFlow. This allowed radical simplification, by implementing the kernel module as a simple hash table
rather than as a complicated, generic packet classifier, supporting arbitrary fields and masking. In this design,
cache entries are extremely fine-grained and match at most packets of a single transport connection: even for a
single transport connection, a change in network path and hence in IP TTL field would result in a miss, and would
divert a packet to userspace, which consulted the actual OpenFlow flow table to decide how to forward it.

Megaflow Caching
^^^^^^^^^^^^^^^^^^^
While the microflow cache works well with most traffic patterns, it suffers serious performance degradation when
faced with large numbers of short lived connections. In this case, many packets miss the cache, and must not only
cross the kernel-userspace boundary, but also execute a long series of expensive packet classifications.

The megaflow cache is a single flow lookup table that supports generic matching, i.e., it supports
caching forwarding decisions for larger aggregates of traffic than connections. While it more closely resembles
a generic OpenFlow table than the microflow cache does, due to its support for arbitrary packet field matching, it
is still strictly simpler and lighter in runtime for two primary reasons. First, it does not have priorities, which
speeds up packet classification: the in-kernel tuple space search implementation can terminate as soon as it finds
any match, instead of continuing to look for a higherpriority match until all the mask-specific hash tables are
inspected. (To avoid ambiguity, userspace installs only disjoint megaflows, those whose matches do not overlap.)
Second, there is only one megaflow classifier, instead of a pipeline of them, so userspace installs megaflow entries 
that collapse together the behavior of all relevant OpenFlow tables.

Open vSwitch addresses the costs of megaflows by retaining the microflow cache as a first-level cache, consulted before the megaflow cache. This cache is a hash table that maps from a microflow to its matching megaflow.
Thus, after the first packet in a microflow passes through the kernel megaflow table, requiring a search of the kernel
classifier, this exact-match cache allows subsequent packets in the same microflow to get quickly directed to the
appropriate megaflow. This reduces the cost of megaflows from per-packet to per-microflow. The exact-match cache
is a true cache in that its activity is not visible to userspace, other than through its effects on performance.

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

network virtualization
=========================

virtio
-----------------
+---------+------+--------+----------+--+

|         +------+        +----------+  |

| user    |      |        |          |  |

| space   |      |        |  guest   |  |

|         |      |        |          |  |

|    +----+ qemu |        | +-+------+  |

|    |    |      |        | | virtio |  |

|    |    |      |        | | driver |  |

|    |    +------+        +-+---++---+  |

|    |                          |       |

|    |       ^                  |       |

|    v       |                  v       |

|            |                          |

+-+-----+-----------------+--+-------+--+

| |tap  |    +------------+ kvm.ko   |  |

| +-----+                 +--+-------+  |

|                kernel                 |

+---------------------------------------+

图中描述了的io路径:guest发出中断信号退出kvm，从kvm退出到用户空间的qemu进程。然后由qemu开始对tap设备进行读写。 可以看到这里从用户态进入内核，再从内核切换到用户态，进行了2次切换。





