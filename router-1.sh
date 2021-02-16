export DEBIAN_FRONTEND=noninteractive

netplan_current=$(sed '/version/d' /etc/netplan/50-cloud-init.yaml)
netplan_additional=\
"        enp0s9:
            dhcp4: false
            addresses: [192.168.3.1/30]
            routes:
            - to: 192.168.4.0/23
              via: 192.168.3.2
        enp0s8: {}

    vlans:
        enp0s8.100:
            id: 100
            link: enp0s8
            addresses: [192.168.1.254/24]
        enp0s8.200:
            id: 200
            link: enp0s8
            addresses: [192.168.2.254/24]
    version: 2
    renderer: networkd"

echo "${netplan_current}" | sudo tee /etc/netplan/50-cloud-init.yaml
echo "${netplan_additional}" | sudo tee -a  /etc/netplan/50-cloud-init.yaml

netplan apply

echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

sysctl -w net.ipv4.ip_forward=1



# # VLAN subinterfaces 
# ip link add link enp0s8 name enp0s8.100 type vlan id 100
# ip link add link enp0s8 name enp0s8.200 type vlan id 200

# ifconfig enp0s8 up
# ifconfig enp0s8.100 192.168.1.254/24 up
# ifconfig enp0s8.200 192.168.2.254/24 up

# # Regular network interface
# ifconfig enp0s9 192.168.3.1/30 up

# # Configuraion of static routes
# ip route add 192.168.4.0/23 via 192.168.3.2 dev enp0s9 

# # Enable IP forwarding
# sysctl -w net.ipv4.ip_forward=1