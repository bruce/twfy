module Twfy

  class Constituency < DataElement

    def geometry
      @geometry ||= @client.geometry(name: @name).with(constituency: self)
    end

    def mp
      @mp ||= @client.mp(constituency: @name).with(constituency: self)
    end

  end

end
