require 'rubygems'
require 'json'

dna = {
  :cluster => {:members => %w[vm-ubuntu-1 vm-ubuntu-2],
                 :ip => "172.16.209.200",
                 :mac => "01:00:5e:10:D1:C8", # multicast mac address starting with 01:00:5e
                 :secret => "whateverdude"},
  :recipes => %w[clusterip]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)
