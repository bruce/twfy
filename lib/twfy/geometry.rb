module Twfy

  class Geometry < DataElement

    convert :constituency do |source, value|
      if value.is_a?(Constituency)
        value
      else
        Constituency.new(source.client,
                         name:     value,
                         geometry: source)
      end
    end

  end

end
