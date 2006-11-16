require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/twfy')

class BasicReturnedDataTest < Test::Unit::TestCase
  
  def setup
    @client = Twfy::Client.new
  end
  
  def test_convert_url
    uri = @client.convert_url(:url=>'http://www.publications.parliament.uk/pa/cm200506/cmhansrd/cm061018/debtext/61018-0002.htm#06101834000471')
    assert_kind_of URI::HTTP, uri
    assert_equal "www.theyworkforyou.com", uri.host
  end
  
  def test_mp_and_mp_info
    mp = @client.mp(:postcode=>'IP6 9PN')
    assert_kind_of Twfy::MP, mp
    assert_kind_of OpenStruct, @client.mp_info(:id=>mp.person_id)
  end
  
  def test_mps
    mps = @client.mps
    assert_kind_of Array, mps
    mps.each do |mp|
      assert_kind_of Twfy::MP, mp
    end
  end
  
  def test_constituency_and_geometry
    c = @client.constituency(:postcode => 'IP6 9PN')
    assert_kind_of Twfy::Constituency, c
    assert_kind_of Twfy::Geometry, @client.geometry(:name=>c.name)
  end
  
  def test_constituencies
    cs = @client.constituencies
    assert_kind_of Array, cs
    cs.each do |c|
      assert_kind_of Twfy::Constituency, c
    end
  end
  
end