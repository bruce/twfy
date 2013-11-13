module Twfy

  class MP < DataElement

    convert_to_date :entered_house, :left_house

    convert :image do |value|
      URI.parse("http://theyworkforyou.com#{value}")
    end

    convert :constituency do |source, value|
      if value.is_a?(Constituency)
        value
      else
        Constituency.new(source.client, name: value, mp: source)
      end
    end

    def in_office?
      @left_reason == 'still_in_office'
    end

    def info
      @info ||= @client.mp_info(id: @person_id)
    end

    def debates(params={})
      @debates ||= {}
      @debates[params] ||= @client.debates(params.merge(person: @person_id, type: 'commons'))
    end

    def comments(params={})
      @comments ||= {}
      @comments[params] ||= @client.comments(params.merge(pid: @person_id))
    end

  end

end
