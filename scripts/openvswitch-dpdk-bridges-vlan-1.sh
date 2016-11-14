#! /bin/sh

# NOTE: On this simple vlan mode example, the stacks can share a single bridge.

# Subscribers DPDK-based Bridge
ovs-vsctl add-br vlans-br-0 -- set bridge vlans-br-0 datapath_type=netdev
ovs-vsctl add-port vlans-br-0 dpdk0 -- set Interface dpdk0 type=dpdk

# Internet DPDK-based Bridge
ovs-vsctl add-br vlans-br-1 -- set bridge vlans-br-1 datapath_type=netdev
ovs-vsctl add-port vlans-br-1 dpdk1 -- set Interface dpdk1 type=dpdk


# Bring it up (not sure if needed)
ip link set dev vlans-br-0 up
ip link set dev vlans-br-1 up


# Enable multi-queue on host side, 4 queues
ovs-vsctl set interface dpdk0 options:n_rxq=4
ovs-vsctl set interface dpdk1 options:n_rxq=4


# Give mode CPU Cores to ovs-vswitchd PMD threads
# ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=FF


# Customer 1 DPDK Ports
ovs-vsctl add-port vlans-br-0 stack-1-pts-1-subscribers-1 -- set Interface stack-1-pts-1-subscribers-1 type=dpdkvhostuser
ovs-vsctl add-port vlans-br-1 stack-1-pts-1-internet-1 -- set Interface stack-1-pts-1-internet-1 type=dpdkvhostuser

# Customer 1 VLAN tags
ovs-vsctl set port stack-1-pts-1-subscribers-1 trunks=100,101
ovs-vsctl set port stack-1-pts-1-internet-1 trunks=100,101


# Customer 2 DPDK Ports
ovs-vsctl add-port vlans-br-0 stack-2-pts-1-subscribers-1 -- set Interface stack-2-pts-1-subscribers-1 type=dpdkvhostuser
ovs-vsctl add-port vlans-br-1 stack-2-pts-1-internet-1 -- set Interface stack-2-pts-1-internet-1 type=dpdkvhostuser

# Customer 2 VLAN tags
ovs-vsctl set port stack-2-pts-1-subscribers-1 trunks=102,103
ovs-vsctl set port stack-2-pts-1-internet-1 trunks=102,103



# Customer 3 DPDK Ports
ovs-vsctl add-port vlans-br-0 stack-3-pts-1-subscribers-1 -- set Interface stack-3-pts-1-subscribers-1 type=dpdkvhostuser
ovs-vsctl add-port vlans-br-1 stack-3-pts-1-internet-1 -- set Interface stack-3-pts-1-internet-1 type=dpdkvhostuser

# Customer 3 VLAN tags
ovs-vsctl set port stack-3-pts-1-subscribers-1 trunks=104,105
ovs-vsctl set port stack-3-pts-1-internet-1 trunks=104,105



# Customer 4 DPDK Ports
ovs-vsctl add-port vlans-br-0 stack-4-pts-1-subscribers-1 -- set Interface stack-4-pts-1-subscribers-1 type=dpdkvhostuser
ovs-vsctl add-port vlans-br-1 stack-4-pts-1-internet-1 -- set Interface stack-4-pts-1-internet-1 type=dpdkvhostuser

# Customer 4 VLAN tags
ovs-vsctl set port stack-4-pts-1-subscribers-1 trunks=106,107
ovs-vsctl set port stack-4-pts-1-internet-1 trunks=106,107
