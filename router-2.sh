export DEBIAN_FRONTEND=noninteractive

netplan_current=$(sed '/version/d' /etc/netplan/50-cloud-init.yaml)
netplan_additional=\
"        enp0s9:
            dhcp4: false
            addresses: [192.168.3.2/30]
            routes:
            - to: 192.168.2.0/24
              via: 192.168.3.1
            - to: 192.168.1.0/24
              via: 192.168.3.1
        enp0s8: 
            dhcp4: false
            addresses: [192.168.5.254/23]
    version: 2
    renderer: networkd"

echo "${netplan_current}" | sudo tee /etc/netplan/50-cloud-init.yaml
echo "${netplan_additional}" | sudo tee -a  /etc/netplan/50-cloud-init.yaml

netplan apply

echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

sysctl -w net.ipv4.ip_forward=1


# # Regular network interface
# ifconfig enp0s9 192.168.3.2/30 up
# ifconfig enp0s8 192.168.5.254/23 up


# # Configuraion of static routes
# ip route add 192.168.2.0/24 via 192.168.3.1 dev enp0s9 
# ip route add 192.168.1.0/24 via 192.168.3.1 dev enp0s9 

# # Enable IP forwarding
# sysctl -w net.ipv4.ip_forward=1