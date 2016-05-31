============================
extra routes for routers
============================

Adds extra routes to the router resource.
You can update a router to add a set of next hop IPs and destination CIDRs.
The next hop IP must be part of a subnet to which the router interfaces are 
connected. You can configure the routes attribute on only update operations.

PUT/v2.0/routers/{router_id}
{
   "router":{
      "routes":[
         {
            "nexthop":"10.1.0.10",
            "destination":"40.0.1.0/24"
         }
      ]
   }
}

response:
{
  "router":
    {"status": "ACTIVE",
     "external_gateway_info": {"network_id": "5c26e0bb-a9a9-429c-9703-5c417a221096"},
     "name": "router1",
     "admin_state_up": true,
     "tenant_id": "936fa220b2c24a87af51026439af7a3e",
     "routes": [{"nexthop": "10.1.0.10", "destination": "40.0.1.0/24"}],
     "id": "babc8173-46f6-4b6f-8b95-38c1683a4e22"}
}

The next hop IP address must be a part of one of the subnets to which the router 
interfaces are connected. Otherwise, the server responds with the Bad Request 
(400) error code.
