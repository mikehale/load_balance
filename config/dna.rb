require 'rubygems'
require 'json'

dna = {
  # :keepalived => {:servers => %w[172.16.209.129 172.16.209.130] },
  # :recipes => [
  #       "keepalived"
  #      ]
  :heartbeat => {:servers => %w[vm-ubuntu-1 vm-ubuntu-2],
                 :service_address => "172.16.209.200",
                 :secret => "whateverdude"},
  :recipes => %w[heartbeat]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)