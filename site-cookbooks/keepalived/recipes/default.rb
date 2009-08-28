package "keepalived"

service "keepalived" do
  action :enable
end

# template "/etc/keepalived/keepalived.conf" do
#   source "keepalived.erb"
#   variables @node[:keepalived]
#   notifies :restart, resources(:service => "keepalived")
# end

template "/etc/keepalived/keepalived.conf" do
  source "active_passive.erb"
  variables :ip => "172.16.209.200"
  notifies :restart, resources(:service => "keepalived")
end