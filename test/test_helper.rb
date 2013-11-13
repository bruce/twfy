$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'twfy'
require 'test/unit'
require 'vcr'

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

class TwfyTest < Test::Unit::TestCase

  def api_key
    @api_key ||= TEST_API_KEY
  end

  def setup
    VCR.insert_cassette self.class.name.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  def teardown
    VCR.eject_cassette
  end

end
