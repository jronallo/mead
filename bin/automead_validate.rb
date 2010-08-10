#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'pp'
require 'rubygems'
require 'automead'

puts "automead_validate: Accept the path to a text file as input. Within the
text file is a line break separated list of meads. Each one is checked for
validity and a report output."

meads = File.open(ARGV[0]).read.split

i = 0
meads.each do |mead|
  automead = Mead::Identifier.new(mead)
  if automead.valid?
    i += 1
  else
    puts 'Invalid mead: ' + mead
    pp automead.errors
    puts
  end
end

puts "Total meads checked: " + meads.length.to_s
puts "Good meads: " + i.to_s
