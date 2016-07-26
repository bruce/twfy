require "test_helper"

class ClientSpec < Twfy::Spec

  describe Twfy::Client, vcr: {record: :new_episodes} do

    before do
      @client = Twfy::Client.new(api_key)
    end

    describe 'convert_url' do
      it 'works' do
        uri = @client.convert_url(url: 'http://www.publications.parliament.uk/pa/cm200506/cmhansrd/cm061018/debtext/61018-0002.htm#06101834000471')
        assert_kind_of URI::HTTP, uri
        assert_equal "www.theyworkforyou.com", uri.host
      end
    end

    describe 'mp_and_mp_info' do
      it 'works' do
        mp = @client.mp(postcode: 'IP6 9PN')
        assert_kind_of Twfy::MP, mp
        assert_kind_of Twfy::Constituency, mp.constituency
        assert_kind_of OpenStruct, @client.mp_info(:id=>mp.person_id)
      end
    end

    describe 'mps' do
      it 'works' do
        mps = @client.mps
        assert_kind_of Array, mps
        mps.each do |mp|
          assert_kind_of Twfy::MP, mp
        end
      end
    end

    describe 'msps' do
      it 'works' do
        msps = @client.msps
        assert_kind_of Array, msps
        msps.each do |msp|
          assert_kind_of OpenStruct, msp
        end
      end
    end

    describe 'constituency' do
      it 'works' do
        c = @client.constituency(postcode: 'IP6 9PN')
        assert_kind_of Twfy::Constituency, c
      end
    end

    describe 'geometry' do
      it 'works' do
        c = @client.constituency(postcode: 'IP6 9PN')
        assert_kind_of Twfy::Geometry, @client.geometry(:name=>c.name)
      end
    end

    describe 'constituencies' do
      it 'works' do
        cs = @client.constituencies
        assert_kind_of Array, cs
        cs.each do |c|
          assert_kind_of Twfy::Constituency, c
        end
      end
    end

  end

end
