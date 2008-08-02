# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'lib/twfy.rb'

Hoe.new('twfy', Twfy::VERSION) do |p|
    p.rubyforge_name = 'twfy'
    p.summary = 'Ruby library to interface with the TheyWorkForYou(.com) API; an information source on Parliament'
    p.description =<<EOD
      Ruby library to interface with the TheyWorkForYou API. TheyWorkForYou.com is 
      "a non-partisan, volunteer-run website which aims to make it easy for people to keep
      tabs on their elected and unelected representatives in Parliament."
EOD
    p.url = "http://twfy.rubyforge.org"
    p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
    p.extra_deps = ['json', 'paginator']
    p.email = %q{bruce@codefluency.com}
    p.author = ["Bruce Williams", "Martin Owen"]
end

# vim: syntax=Ruby
