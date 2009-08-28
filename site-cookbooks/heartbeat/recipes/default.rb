package "heartbeat"

service "heartbeat" do
  supports(
    :start => true,
    :restart => true,
    :status => true,
    :reload => true
  )
  action :enable
end

bash "sysctl" do
  code "/sbin/sysctl -p"
end

template "/etc/ha.d/ha.cf" do
  source "ha.cf.erb"
  variables :servers => node[:heartbeat][:servers], 
            :interfaces => %w[eth0],
            :router => "172.16.209.2"
  notifies :reload, resources(:service => "heartbeat")
end

template "/etc/ha.d/haresources" do
  source "haresources.erb"
  notifies :reload, resources(:service => "heartbeat")
end

template "/etc/ha.d/authkeys" do
  source "authkeys.erb"
  notifies :reload, resources(:service => "heartbeat")
end

template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
  notifies :run, resources(:bash => "sysctl")
end

service "heartbeat" do
  action :enable
end
