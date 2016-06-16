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



   def get_cidr_by_port(self, lport):
        lswitch_id = lport.get_lswitch_id()
        lswitch = self.db_store.get_lswitch(lswitch_id)
        port_ip = lport.get_ip()
        for subnet in lswitch.get_subnets():
            cidr = netaddr.IPNetwork(subnet.get_cidr())
            if netaddr.IPNetwork(port_ip+'/'+str(cidr.prefixlen)) == \
                    cidr.network:
                return cidr
        else:
            raise Exception('Port has illegal ip %s ' % str(lport))

    def add_router_route(self, router, route):
        LOG.info(_LI('Add extra route %(route)s for router %(router)s') %
                 {'route': route, 'router': router.get_id()})

        datapath = self.get_datapath()
        parser = datapath.ofproto_parser

        destination = route.get('destination')
        destination = netaddr.IPNetwork(destination)
        nexthop = route.get('nexthop')
        topic = router.get_topic()

        # Get external port corresponding the next hop
        ports = self.db_store.get_ports(topic)
        for port in ports:
            if port.get_ip() == nexthop:
                nexthop_port = port
        else:
            LOG.error(_LE("Port not found"))
            return

        nexthop_cidr = self.get_cidr_by_port(nexthop_port)
        # Get router interface port corresponding to the next hop
        for port in router.get_ports():
            if port.get_cidr() == nexthop_cidr:
                break
        else:
            LOG.error(_LE("Router interface not found"))
            return


        # Install openflow entry for the route
        # Match: ip, metadata=network_id, nw_src=src_network/mask,
        #        nw_dst=dst_network/mask,
        # Actions:ttl-1, mod_dl_dst=next_hop_mac, load_reg7=next_hop_port_key,
        #         goto: egress_table
        dst_mac = nexthop_port.get_mac()
        tunnel_key = nexthop_port.get_tunnel_key()
        src_network = nexthop_port.network
        src_netmask = nexthop_port.netmask
        dst_network = destination.network
        dst_netmask = destination.netmask

        if netaddr.IPAddress(dest).version == 4:
            match = parser.OFPMatch(eth_type=ether.ETH_TYPE_IP,
                                    metadata=network_id,
                                    ipvs_src=(src_network, src_netmask),
                                    ipv4_dst=(dst_network, dst_netmask))
        else:
            match = parser.OFPMatch(eth_type=ether.ETH_TYPE_IPV6,
                                    ipvs_src=(src_network, src_netmask),
                                    ipv6_dst=(dst_network, dst_netmask))

        actions = []
        actions.append(parser.OFPActionDecNwTtl())
        actions.append(parser.OFPActionSetField(eth_dst=dst_mac))
        actions.append(parser.OFPActionSetField(reg7=tunnel_key))
        action_inst = self.get_datapath().ofproto_parser.OFPInstructionActions(
            ofproto.OFPIT_APPLY_ACTIONS, actions)
        goto_inst = parser.OFPInstructionGotoTable(
            const.EGRESS_TABLE)

        inst = [action_inst, goto_inst]

        self.mod_flow(
            self.get_datapath(),
            cookie=tunnel_key,
            inst=inst,
            table_id=const.L3_LOOKUP_TABLE,
            priority=const.PRIORITY_MEDIUM,
            match=match)
