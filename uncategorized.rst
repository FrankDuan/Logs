mock

1. how to capture input


Toefl:

Integration Writing:

1. accurate development
  a) how well you seleclt important information from the lecture.
  b) how well you present it in relation to relevant information in the reading
2. organization
  a) write in paragraphs
  b) use tansitions
  c) avoid redundancy
3. language use
  a) sentence structure
  b) workd choice
  c) vocabulary
  d) use of grammar
Tips:

1. Practise paraphrasing, which is expressing the same idea in different ways.
2. Build your vocabulary. Practice using synonyms when you write.
3. Pratice identifying main points. Listen to recorded lestures and write down the main points.
4. Read two articles that are in the same topic and write summary of each. Explain the ways they are similar and the ways they are different.




    def _get_cidr_by_port(self, lport):
        lswitch_id = lport.get_lswitch_id()
        lswitch = self.db_store.get_lswitch(lswitch_id)
        port_ip = lport.get_ip()
        for subnet in lswitch.get_subnets():
            cidr = netaddr.IPNetwork(subnet.get_cidr())
            if netaddr.IPNetwork(port_ip + '/' + str(cidr.prefixlen)).cidr == \
                    cidr:
                return cidr
        else:
            raise Exception('Port has illegal ip %s ' % str(lport))

    def _get_port_by_ip_and_topic(self, ip, topic):
        ports = self.db_store.get_ports(topic)
        for port in ports:
            if port.get_ip() == ip:
                return port

        raise Exception('Port not found')

    def _get_router_port_by_cidr(self, router, cidr):
        for port in router.get_ports():
            if port.get_cidr_network() == cidr:
                return port

        raise Exception('Port not found')

    def add_router_route(self, router, route):
        LOG.info(_LI('Add extra route %(route)s for router %(router)s') %
                 {'route': route, 'router': router.__str__()})

        datapath = self.get_datapath()
        ofproto = self.get_datapath().ofproto
        parser = datapath.ofproto_parser

        destination = route.get('destination')
        destination = netaddr.IPNetwork(destination)
        nexthop_port = self._get_port_by_ip_and_topic(route.get('nexthop'),
                                                      router.get_topic())
        nexthop_cidr = self._get_cidr_by_port(nexthop_port)
        # Get router interface port corresponding to the next hop
        self._get_router_port_by_cidr(router, str(nexthop_cidr.network))

        # Install openflow entry for the route
        # Match: ip, metadata=network_id, nw_src=src_network/mask,
        #        nw_dst=dst_network/mask,
        # Actions:ttl-1, mod_dl_dst=next_hop_mac, load_reg7=next_hop_port_key,
        #         goto: egress_table
        dst_mac = nexthop_port.get_mac()
        tunnel_key = nexthop_port.get_tunnel_key()
        network_id = nexthop_port.get_external_value('local_network_id')
        src_network = nexthop_cidr.network
        src_netmask = nexthop_cidr.netmask
        dst_network = destination.network
        dst_netmask = destination.netmask

        if destination.version == 4:
            match = parser.OFPMatch(eth_type=ether.ETH_TYPE_IP,
                                    metadata=network_id,
                                    ipv4_src=(src_network, src_netmask),
                                    ipv4_dst=(dst_network, dst_netmask))
        else:
            match = parser.OFPMatch(eth_type=ether.ETH_TYPE_IPV6,
                                    ipv4_src=(src_network, src_netmask),
                                    ipv6_dst=(dst_network, dst_netmask))

        actions = [
            parser.OFPActionDecNwTtl(),
            parser.OFPActionSetField(eth_dst=dst_mac),
            parser.OFPActionSetField(reg7=tunnel_key),
        ]
        action_inst = self.get_datapath().ofproto_parser.OFPInstructionActions(
            ofproto.OFPIT_APPLY_ACTIONS, actions)
        goto_inst = parser.OFPInstructionGotoTable(const.EGRESS_TABLE)

        inst = [action_inst, goto_inst]

        self.mod_flow(
            self.get_datapath(),
            cookie=tunnel_key,
            inst=inst,
            table_id=const.L3_LOOKUP_TABLE,
            priority=const.PRIORITY_VERY_HIGH,
            match=match)

    def remove_router_route(self, router, route):
        LOG.info(_LI('Delete extra route %(route)s from router %(router)s') %
                 {'route': route, 'router': router.__str__()})
        datapath = self.get_datapath()
        ofproto = self.get_datapath().ofproto
        parser = datapath.ofproto_parser

        destination = route.get('destination')
        destination = netaddr.IPNetwork(destination)
        nexthop_port = self._get_port_by_ip_and_topic(route.get('nexthop'),
                                                      router.get_topic())
        nexthop_cidr = self._get_cidr_by_port(nexthop_port)
        # Get router interface port corresponding to the next hop
        self._get_router_port_by_cidr(router, str(nexthop_cidr.network))

        # Install openflow entry for the route
        # Match: ip, metadata=network_id, nw_src=src_network/mask,
        #        nw_dst=dst_network/mask,
        # Actions:ttl-1, mod_dl_dst=next_hop_mac, load_reg7=next_hop_port_key,
        #         goto: egress_table
        network_id = nexthop_port.get_external_value('local_network_id')
        src_network = nexthop_cidr.network
        src_netmask = nexthop_cidr.netmask
        dst_network = destination.network
        dst_netmask = destination.netmask

        if destination.version == 4:
            match = parser.OFPMatch(eth_type=ether.ETH_TYPE_IP,
                                    metadata=network_id,
                                    ipv4_src=(src_network, src_netmask),
                                    ipv4_dst=(dst_network, dst_netmask))
        else:
            match = parser.OFPMatch(eth_type=ether.ETH_TYPE_IPV6,
                                    ipv6_src=(src_network, src_netmask),
                                    ipv6_dst=(dst_network, dst_netmask))

        self.mod_flow(
            self.get_datapath(),
            command=ofproto.OFPFC_DELETE,
            table_id=const.L3_LOOKUP_TABLE,
            priority=const.PRIORITY_VERY_HIGH,
            out_port=ofproto.OFPP_ANY,
            out_group=ofproto.OFPG_ANY,
            match=match)

****** Independent writing:
1. Read opinion essays and write about them
2. Timing yourself, plan, write and revise in 30 minutes.
3. Learn how to find and correct grammar mistakes.


