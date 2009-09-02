service "heartbeat" do
  action :stop
end

bash "install modules" do
  code "modprobe ipt_CLUSTERIP && modprobe ipt_conntrack"
end

bash "add clusterip rule to iptables" do
  local_node = node[:cluster][:members].index(node[:hostname]) + 1
  total_nodes = node[:cluster][:members].size
  
  code %(iptables -F INPUT && 
         iptables -I INPUT -d #{node[:cluster][:ip]} -i eth0 -j CLUSTERIP \
            --new --clustermac #{node[:cluster][:mac]} --total-nodes #{total_nodes} \
            --local-node #{local_node} --hashmode sourceip --hash-init 5567)
end

bash "add shared ip to interface" do
  code "ip address add #{node[:shared_ip]} dev eth0 || true"
end

# TODO: connect to heartbeat/keepalived to run a script when one of the nodes is dead like:
# echo "+1" > /proc/net/ipt_CLUSTERIP/192.168.1.1 or 
# echo "-1" > /proc/net/ipt_CLUSTERIP/192.168.1.1
