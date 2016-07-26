require "test_helper.rb"

class DataElementSpec < Twfy::Spec

  describe Twfy::DataElement, :vcr do

    before do
      @client = Twfy::Client.new(api_key)
      @mp = @client.mp(postcode: 'IP6 9PN')
    end

    it 'works for a single chain' do
      assert_kind_of Twfy::Constituency, @mp.constituency
      c = @mp.instance_eval{ @constituency }
      assert c
      assert_kind_of Twfy::Constituency, c
    end

    it 'works for a reflexive chain' do
      c = @mp.constituency
      assert_kind_of Twfy::Constituency, c
      mp = @mp.constituency.mp
      assert_kind_of Twfy::MP, mp
      assert c.instance_eval{ @mp }
      assert_equal mp, c.instance_eval{ @mp }
    end

    it 'works for a round trip chain' do
      c = @mp.constituency
      assert_kind_of Twfy::Constituency, c
      c2 = @mp.constituency.mp.constituency
      assert_kind_of Twfy::Constituency, @mp.instance_eval{ @constituency }
      assert_kind_of Twfy::MP, @mp.constituency.instance_eval{ @mp }
      assert_kind_of Twfy::Constituency, @mp.constituency.mp.instance_eval{ @constituency }
      assert_kind_of Twfy::Constituency, c2
      assert_equal c.name, c2.name
    end

    it 'works for an overkill chain' do
      mp = @mp.constituency.mp.constituency.geometry.constituency.mp
      assert_kind_of Twfy::MP, mp
      assert_equal @mp.full_name, mp.full_name
    end

    it 'is equivalent to use a simple_chain or direct call' do
      assert_equal @client.mp_info(id: @mp.person_id), @mp.info
    end

  end

end
