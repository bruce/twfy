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
      update_attributes(data)
    end

    def update_attributes(data = {})
      data.each do |field,value|
        instance_variable_set("@#{field}", convert(field, value))
        unless self.respond_to?(field)
          self.class.send(:define_method, field) do
            instance_variable_get("@#{field}")
          end
        end
      end
    end

    def with(data = {})
      update_attributes(data)
      self
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

end
