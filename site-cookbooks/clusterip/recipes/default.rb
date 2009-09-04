service "heartbeat" do
  action :stop
end

kernel_module "nf_conntrack"
kernel_module "ipt_CLUSTERIP"

local_node = node[:cluster][:members].index(node[:hostname]) + 1
total_nodes = node[:cluster][:members].size
other_nodes = (1..total_nodes).to_a - [local_node]

bash "add clusterip rule to iptables" do
  filter = "-d #{node[:cluster][:ip]} -i #{node[:cluster][:interface]}"
  
  code %(iptables -F INPUT && 
         iptables -A INPUT #{filter} -j CLUSTERIP \
            --new --clustermac #{node[:cluster][:mac]} \
            --total-nodes #{total_nodes} \
            --local-node #{local_node} \
            --hashmode #{node[:cluster][:hash_mode]} \
            --hash-init #{node[:cluster][:hash_init]} &&
         iptables -A INPUT #{filter} -j LOG --log-level debug --log-tcp-sequence --log-tcp-options --log-ip-options)
end

bash "add shared ip #{node[:cluster][:ip]} to #{node[:cluster][:interface]}" do
  code "ip address add #{node[:cluster][:ip]} dev #{node[:cluster][:interface]}"
  not_if "ip address list #{node[:cluster][:interface]} | grep #{node[:cluster][:ip]}"
end

clusterip_scripts_dir = "/etc/init.d/clusterip/#{node[:cluster][:ip]}"
directory(clusterip_scripts_dir) do
  recursive true
end

template "#{clusterip_scripts_dir}/down" do
  source "up_down.sh.erb"
  mode 0555
  backup 0
  variables :up => false, :this_node => local_node, :cluster_ip => node[:cluster][:ip]
end

template "#{clusterip_scripts_dir}/up" do
  source "up_down.sh.erb"
  mode 0555
  backup 0
  variables :up => true, :this_node => local_node, :cluster_ip => node[:cluster][:ip]
end

template "#{clusterip_scripts_dir}/be_master" do
  source "be.sh.erb"
  mode 0555
  backup 0
  variables :master => true, :other_nodes => other_nodes, :cluster_ip => node[:cluster][:ip]
end

template "#{clusterip_scripts_dir}/be_self" do
  source "be.sh.erb"
  mode 0555
  backup 0
  variables :master => false, :other_nodes => other_nodes, :cluster_ip => node[:cluster][:ip]
end
