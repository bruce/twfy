$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'twfy'
require 'test/unit'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

class VCRTest < Test::Unit::TestCase
  def test_example_dot_com
    VCR.use_cassette('synopsis') do
      response = Net::HTTP.get_response(URI('http://www.iana.org/domains/reserved'))
      assert_match /Example domains/, response.body
    end
  end
end

class TwfyTest < Test::Unit::TestCase

  def api_key
    @api_key ||= File.read(File.expand_path('../api_key', __FILE__)).strip
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
