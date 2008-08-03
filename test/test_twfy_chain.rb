require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/twfy')

class ChainDataTest < Test::Unit::TestCase

  API_KEY_LOCATION = File.join(File.dirname(__FILE__), 'api_key')

  def setup
    api_key = File.open(API_KEY_LOCATION){ |f| f.readlines[0].chomp }
    @client = Twfy::Client.new(api_key)
    @mp = @client.mp(:postcode=>'IP6 9PN')
  end
  
  def test_single_chain_class
    assert_kind_of Twfy::Constituency, @mp.constituency
    c = @mp.instance_eval{ @constituency }
    assert c
    assert_kind_of Twfy::Constituency, c
  end
  
  def test_reflexive_chain_class
    c = @mp.constituency
    assert_kind_of Twfy::Constituency, c
    mp = @mp.constituency.mp
    assert_kind_of Twfy::MP, mp
    assert c.instance_eval{ @mp }
    assert_equal mp, c.instance_eval{ @mp }
  end
  
  def test_round_trip_chain_class
    c = @mp.constituency
    assert_kind_of Twfy::Constituency, c
    c2 = @mp.constituency.mp.constituency
    assert_kind_of Twfy::Constituency, @mp.instance_eval{ @constituency }
    assert_kind_of Twfy::MP, @mp.constituency.instance_eval{ @mp }
    assert_kind_of Twfy::Constituency, @mp.constituency.mp.instance_eval{ @constituency }
    assert_kind_of Twfy::Constituency, c2
    assert_equal c.name, c2.name
  end
  
  def test_overkill_chain_class
    mp = @mp.constituency.mp.constituency.geometry.constituency.mp
    assert_kind_of Twfy::MP, mp
    assert_equal @mp.full_name, mp.full_name    
  end
  
  def test_simple_chain_and_direct_call_are_equivalent
    assert_equal @client.mp_info(:id=>@mp.person_id), @mp.info
  end
  
end
  
