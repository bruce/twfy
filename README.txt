twfy
    by Bruce Williams
    http://codefluency.com

== DESCRIPTION:
  
Ruby library to interface with the TheyWorkForYou API.

From their website:

"TheyWorkForYou.com is a non-partisan, volunteer-run website which aims to make it easy
for people to keep tabs on their elected and unelected representatives in Parliament."

== FEATURES/PROBLEMS:
  
All services [currently] provided by the API are supported.

The Ruby API closely mirrors that of TWFY, with the exception that the client
methods are in lowercase and don't include the 'get' prefix.

Some examples:

getComments:: comments
getMPs:: mps
getMPInfo:: mp_info

Please submit bug reports to the RubyForge tracker via the project's homepage at
http://rubyforge.org/projects/twfy

== SYNOPSYS:

Use is very easy.  

All API calls return either OpenStructs or arrays of OpenStructs

  require 'twfy'
  client = Twfy::Client.new

  # Call API methods on client

  puts client.constituency(:postcode=>'IP6 9PN').name
  # => Central Suffolk & North Ipswich

  puts client.mp(:postcode=>'IP6 9PN').full_name
  # => Michael Lord

  # Get a *lot* of info about this MP
  info = client.mp_info(:id=>mp.person_id)

  # Get a sorted list of all the parties in the House of Lords
  client.lords.map{|l| l.party}.uniq.sort
	#=> ["Bishop", "Conservative", "Crossbench", "DUP", "Green", "Labour", "Liberal Democrat", "Other"]

  # Get number of debates in the House of Commons mentioning 'Iraq'
  number = client.debates(:type=>'commons',:search=>'Iraq').info['total_results']
  
See http://www.theyworkforyou.com/api/docs for API documentation.

Please note that data pulled from the API is licensed separately;
see the LICENSE portion of this README for further details.

== REQUIREMENTS:

+ json library (available as a gem)

== INSTALL:

No special instructions.

== LICENSE:

(The Creative Commons Share-Alike License)
http://creativecommons.org/licenses/by-sa/2.5/
Copyright (c) 2006 Bruce Williams

The TheyWorkForYou license statement, from their website (http://www.theyworkforyou.com/api/), is:

To use parliamentary material yourself (that's data returned from getDebates, getWrans, and getWMS), you will need to get a Parliamentary Licence from the Office of Public Sector Information. Our own data - lists of MPs, Lords, constituencies and so on - is available under the Creative Commons Attribution-ShareAlike license version 2.5.

Non-commercial use is free, please contact us for commercial use.
