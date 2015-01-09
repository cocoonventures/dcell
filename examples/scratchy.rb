#!/usr/bin/env ruby
require 'dcell'
require 'dcell/registries/redis_adapter'

registry = DCell::Registry::RedisAdapter.new :server => 'localhost'
DCell.start :registry => registry
itchy_node = DCell::Node["itchy"]
itchy = itchy_node[:itchy]

puts "All itchy actors: #{itchy_node.all}"
puts "Fighting itchy! (check itchy's output)"

300.times do
  begin
    itchy.async.fight
    future = itchy.future.fight
    puts itchy_node[:itchy].fight
    puts itchy.fight
    puts future.value
  rescue Celluloid::DeadActorError
    puts "Itchy dying?"
    itchy = itchy_node[:itchy]
  rescue Celluloid::Task::TerminatedError
    puts "Itchy is dead =/."
    break
  rescue => e
    puts "Unknow error #{e.class} => #{e}"
    break
  end
  sleep 1
end
