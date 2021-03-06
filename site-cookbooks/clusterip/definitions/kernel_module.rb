define :kernel_module, :action => :install do
  if params[:action] == :install
    bash "modprobe #{params[:name]}" do
      code "modprobe #{params[:name]}"
      not_if "lsmod |grep #{params[:name]}"
    end

    bash "install #{params[:name]} in /etc/modules" do
      code "echo '#{params[:name]}' >> /etc/modules"
      not_if "grep '^#{params[:name]}$' /etc/modules"
    end
  end
end
