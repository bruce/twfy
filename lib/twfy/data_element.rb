require 'uri'
require 'date'

module Twfy
  
  class DataElement
    @@conversions = {}
    class << self
      def convert(*fields,&block)
        fields.each do |field|
          @@conversions[field] = block 
        end
      end
      def convert_to_date(*fields)
        fields.each do |field|
          convert field do |d|
            Date.parse(d)
          end
        end
      end
    end
    
    attr_reader :client
    def initialize(client, data={})
      @client = client
      data.each do |field,value|
        instance_variable_set("@#{field}", convert(field, value))
        unless self.respond_to?(field)
          self.class.send(:define_method, field) do
            instance_variable_get("@#{field}")
          end
        end
      end
    end
    
    def convert(field, value)
      if conversion = @@conversions[field.to_sym]
        args = [value]
        args.unshift self if conversion.arity == 2
        conversion.call(*args)
      else
        value
      end
    end
    
  end
  
  class MP < DataElement
    
    convert_to_date :entered_house, :left_house
    convert :image do |value|
      URI.parse("http://theyworkforyou.com#{value}")
    end
    convert :constituency do |source,value|
      Constituency.new(source.client, :name => value, :mp => source)
    end
    
    def in_office?
      @left_reason == 'still_in_office'
    end
    
    def info
      @info ||= @client.mp_info(:id => @person_id)
    end
    
    def debates(params={})
      @debates ||= {}
      @debates[params] ||= @client.debates(params.merge(:person=>@person_id, :type=>'commons'))
    end
    
    def comments(params={})
      @comments ||= {}
      @comments[params] ||= @client.comments(params.merge(:pid=>@person_id))
    end
    
  end
  
  class Constituency < DataElement
    
    def initialize(*args)
      super
    end
    def geometry
      @geometry ||= @client.geometry(:name=>@name)
    end
    
    def mp
      @mp ||= @client.mp(:constituency=>@name)
    end
    
  end
  
  class Geometry < DataElement
    
    convert :constituency do |source,value|
      Constituency.new(source.client, :name => value, :geometry => source)
    end
    
  end
  
end