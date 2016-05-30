============================
extra routes for routers
============================

Adds extra routes to the router resource.
You can update a router to add a set of next hop IPs and destination CIDRs.
The next hop IP must be part of a subnet to which the router interfaces are 
connected. You can configure the routes attribute on only update operations.

PUT/v2.0/routers/{router_id}
"router": {
  routes: [
    {
      "nexthop":"IPADDRESS",
      "destination":"CIDR"
    }
  ]
}

The next hop IP address must be a part of one of the subnets to which the router 
interfaces are connected. Otherwise, the server responds with the Bad Request 
(400) error code.
