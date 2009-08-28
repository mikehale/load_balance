require File.join(File.dirname(__FILE__), 'config', 'rake')
load 'sprinkle_chef/Rakefile'
load 'lib/dns.rb'
load 'lib/chef-repo.rb'

desc "Create dna.json from dna.rb file"
task :create_dna  do
  dna_file = File.join(File.dirname(__FILE__), "config", "dna.rb")
  raise "There is no config/dna.rb file! Take care of that!" unless File.exists? dna_file 
  sh "ruby #{dna_file}"
end

task :update_config => :create_dna do
  remote("mkdir -p /etc/chef")
  rsync("#{TOPDIR}/config/*", "/etc/chef/")
  File.delete(File.dirname(__FILE__) + "/config/dna.json")
end

desc "rsync the cookbooks to #{HOST}"
task :update_cookbooks do
  remote("mkdir -p /var/chef")
  ['site-cookbooks', 'cookbooks'].each do |name|
    rsync("#{File.join(TOPDIR, name)}/", "/var/chef/#{name}", "--exclude=openldap --exclude=quick_start")
  end
end

desc "Run chef-solo on #{HOST}"
task :run_chef_solo => [:update_config, :update_cookbooks] do
  command = "chef-solo -j /etc/chef/dna.json -c /etc/chef/solo.rb"
  command << " -l debug" if ENV.has_key? 'debug'
  remote(command)
end

task :install_custom_chef do
  rsync("chef-0.6.2.gem", "")
  remote "gem install chef-0.6.2.gem"
end

def rsync(src, dest, args="")
  HOSTS.each do |host|
    sh "#{RSYNC} #{args} #{src} root@#{host}:#{dest}"
  end
end

def remote(cmd)
  HOSTS.each do |host|
    sh "ssh root@#{host} '#{cmd}'"
  end
end

task :default => :run_chef_solo

desc "Automatically initialze #{HOST} from scratch. You should only have to enter the root password once."
task(:initialize_host => ['add_ssh_key', 'chef:solo', 'install_custom_chef', 'run_chef_solo']) {}
