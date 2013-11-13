# They Work For You

A Ruby library to interface with the
[TheyWorkForYou](http://www.theyworkforyou.com) API.

## Features

The Ruby API closely mirrors that of TWFY, with the exception that the client
methods are in lowercase and don't include the `get` prefix.

Some examples:

 * `getComments` -> `comments`
 * `getMPs` -> `@mps`
 * `getMPInfo` -> `mp_info`

## Requirements

Ruby 1.9+

 * multi_json
 * paginator

## Examples

### Get a Client

```ruby
require 'twfy'
client = Twfy::Client.new("YOUR-API-KEY")
```

You can get an API key from http://www.theyworkforyou.com/api/key

### Call API methods directly on client

```ruby
puts client.constituency(postcode: 'IP6 9PN').name
# => Central Suffolk & North Ipswich

mp = client.mp(postcode: 'IP6 9PN')
puts mp.full_name
# => Michael Lord

# Get a *lot* of info about this MP
info = client.mp_info(id: mp.person_id)

# Get a sorted list of all the parties in the House of Lords
client.lords.map(&:party).uniq.sort
# => ["Bishop", "Conservative", "Crossbench", "DUP", "Green", "Labour", "Liberal Democrat", "Other"]

# Get number of debates in the House of Commons mentioning 'Iraq'
number = client.debates(type: 'commons', search: 'Iraq').info['total_results']
```

### Daisy Chaining

A few methods on the client return non-OpenStruct instances that
support daisy chaining.  Using these to access related data more
naturally (with caching).

Here are some examples

```ruby
# Get the MP for the last constituency (if you sort them alphabetically)
mp = client.constituencies.sort_by(&:name).last.mp
# get the geometry information for that constituency (coming from the MP)
geometry = mp.constituency.geometry

# An overkill example showing caching (no services are called here, since
# the results have already been cached from above)
mp = mp.constituency.mp.constituency.geometry.constituency.mp

# These return equivalent results (Note how much easier the first is)
info1 = mp.info # this is cached for subsequent calls
info2 = client.mp_info(id: mp.person_id)

# Get pages of debates mentioning 'medicine'
debates1 = mp.debates(search: 'medicine')
debates2 = mp.debates(search: 'medicine', page: 2)
```

See http://www.theyworkforyou.com/api/docs for API documentation.

## Support

Please submit issues to https://github.com/bruce/twfy/issues

Pull requests gratefully accepted.

## License

See LICENSE.txt.

Please note that data pulled from the API is licensed separately from
this library.
