#! /bin/bash

# NOTE: On this simple flat mode example (i.e., no VLAN trunks or tags), the
#  "stack-1" owns the entire bridge!

# Subscribers DPDK-based Bridge
ovs-vsctl add-br flat-br-0 -- set bridge flat-br-0 datapath_type=netdev
ovs-vsctl add-port flat-br-0 dpdk0 -- set Interface dpdk0 type=dpdk
ovs-vsctl add-port flat-br-0 stack-1-pts-1-subscribers-1 -- set Interface stack-1-pts-1-subscribers-1 type=dpdkvhostuser


# Internet DPDK-based Bridge
ovs-vsctl add-br flat-br-1 -- set bridge flat-br-1 datapath_type=netdev
ovs-vsctl add-port flat-br-1 dpdk1 -- set Interface dpdk1 type=dpdk
ovs-vsctl add-port flat-br-1 stack-1-pts-1-internet-1 -- set Interface stack-1-pts-1-internet-1 type=dpdkvhostuser


# Bring it up (not sure if needed)
ip link set dev flat-br-0 up
ip link set dev flat-br-1 up


# Enable multi-queue on host side, 4 queues
ovs-vsctl set interface dpdk0 options:n_rxq=4
ovs-vsctl set interface dpdk1 options:n_rxq=4


# Give mode CPU Cores to ovs-vswitchd PMD threads
# ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=FF


# Ninja OpenFlow rules
ovs-ofctl add-flow flat-br-0 "in_port=1, actions=mod_vlan_vid:2600,2"
ovs-ofctl add-flow flat-br-1 "in_port=1, actions=mod_vlan_vid:2500,2"
