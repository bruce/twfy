$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'twfy'

require 'minitest/autorun'

require 'vcr'
require 'minitest-vcr'

# If you need to record new episodes, run rake with:
#
#   $ rake test API_KEY=YOUR-REAL-API-KEY
#
TEST_API_KEY = ENV['API_KEY'] || 'TEST_API_KEY'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data("<API_KEY>") { TEST_API_KEY }
  c.default_cassette_options = {record: :new_episodes}
end

MinitestVcr::Spec.configure!

class Twfy::Spec < Minitest::Spec

  def api_key
    @api_key ||= TEST_API_KEY
  end

end
