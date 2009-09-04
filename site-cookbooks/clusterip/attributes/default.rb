cluster Mash.new unless attribute?("cluster")
set_unless[:cluster][:interface] = "eth0"
set_unless[:cluster][:hash_mode] = "sourceip-sourceport-destport"
set_unless[:cluster][:hash_init] = "4567"
