require 'uri'

module Twfy

  BASE        = URI.parse('http://www.theyworkforyou.com/api/')
  API_VERSION = '1.0.0'

  autoload :VERSION,     'twfy/version'
  autoload :Client,      'twfy/client'
  autoload :Validation,  'twfy/validation'

  autoload :DataElement,  'twfy/data_element'
  autoload :Constituency, 'twfy/constituency'
  autoload :Geometry,     'twfy/geometry'
  autoload :MP,           'twfy/mp'

  autoload :Commands,   'twfy/commands'
  autoload :API,        'twfy/api'

end
