netplan_current=$(sed '/version/d' /etc/netplan/50-cloud-init.yaml)
netplan_additional=\
"        enp0s8:
            dhcp4: false
            addresses: [192.168.4.1/23]
            gateway4: 192.168.5.254
    version: 2
    renderer: networkd"

echo "${netplan_current}" | sudo tee /etc/netplan/50-cloud-init.yaml
echo "${netplan_additional}" | sudo tee -a  /etc/netplan/50-cloud-init.yaml

netplan apply