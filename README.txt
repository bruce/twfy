twfy
    by Bruce Williams (http://codefluency.com)
    and Martin Owen (http://martinowen.net)

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

== SYNOPSIS:

Use is very easy.  

=== Get a Client

  require 'twfy'
  client = Twfy::Client.new(<YOUR API KEY HERE>)

Note that the Twfy::Client constructor in version 1.0.1 of the binding requires an API Key
string. If you don't have one they are available at http://www.theyworkforyou.com/api/key

=== Call API methods directly on client

  puts client.constituency(:postcode=>'IP6 9PN').name
  # => Central Suffolk & North Ipswich

  mp = client.mp(:postcode=>'IP6 9PN')
  puts mp.full_name
  # => Michael Lord

  # Get a *lot* of info about this MP
  info = client.mp_info(:id=>mp.person_id)

  # Get a sorted list of all the parties in the House of Lords
  client.lords.map{|l| l.party}.uniq.sort
	#=> ["Bishop", "Conservative", "Crossbench", "DUP", "Green", "Labour", "Liberal Democrat", "Other"]

  # Get number of debates in the House of Commons mentioning 'Iraq'
  number = client.debates(:type=>'commons',:search=>'Iraq').info['total_results']

=== Daisy chaining

A few methods on the client return non-OpenStruct instances that support daisy chaining.  Using these to access related data more naturally (with caching).

Here are some examples

  # Get the MP for the last constituency (if you sort them alphabetically) 
  mp = client.constituencies.sort_by{|c| c.name }.last.mp
  # get the geometry information for that constituency (coming from the MP)
  geometry = mp.constituency.geometry

  # An overkill example showing caching (no services are called here, since
  # the results have already been cached from above)
  mp = mp.constituency.mp.constituency.geometry.constituency.mp

  # These return equivalent results (Note how much easier the first is)
  info1 = mp.info # this is cached for subsequent calls
  info2 = client.mp_info(:id=>mp.person_id)

  # Get pages of debates mentioning 'medicine'
  debates1 = mp.debates(:search=>'medicine')
  debates2 = mp.debates(:search=>'medicine', :page=>2)
  
See http://www.theyworkforyou.com/api/docs for API documentation.

Please note that data pulled from the API is licensed separately;
see the LICENSE portion of this README for further details.

== REQUIREMENTS:

+ json library (available as a gem)

== INSTALL:

No special instructions.

== LICENSE:

This library uses the MIT License
Copyright (c) 2006 Bruce Williams

Data is licensed separately:

The TheyWorkForYou license statement, from their website (http://www.theyworkforyou.com/api/), is:

To use parliamentary material yourself (that's data returned from getDebates, getWrans, and getWMS), you will need to get a Parliamentary Licence from the Office of Public Sector Information. Our own data - lists of MPs, Lords, constituencies and so on - is available under the Creative Commons Attribution-ShareAlike license version 2.5.

Non-commercial use is free, please contact us for commercial use.
