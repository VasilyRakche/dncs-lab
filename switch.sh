export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

# Switch condiguration
ovs-vsctl add-br br0
ovs-vsctl add-port br0 enp0s8 trunk=[100,200]
ovs-vsctl add-port br0 enp0s9 tag=100
ovs-vsctl add-port br0 enp0s10 tag=200

netplan_current=$(sed '/version/d' /etc/netplan/50-cloud-init.yaml)
netplan_additional=\
"        enp0s8: {}
        enp0s9: {}
        enp0s10: {}
        br0: {}
    version: 2
    renderer: networkd"

echo "${netplan_current}" | sudo tee /etc/netplan/50-cloud-init.yaml
echo "${netplan_additional}" | sudo tee -a  /etc/netplan/50-cloud-init.yaml

netplan apply
