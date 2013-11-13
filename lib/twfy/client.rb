require 'cgi'
require 'logger'
require 'multi_json'
require 'open-uri'
require 'ostruct'

module Twfy

  class Client
    include API
    include Commands

    class Error < ::StandardError; end
    class APIError < ::StandardError; end

    def initialize(api_key, log_to=$stderr)
      @api_key = api_key
      @logger = Logger.new(log_to)
    end

    def log(message, level=:info)
      @logger.send(level, message) if $DEBUG
    end

    private

    def service(name, params = {}, target = OpenStruct, &block)
      log "Calling service #{name}"
      url = service_url(name, params)
      result = MultiJson.load(url.read)
      log result.inspect
      unless result.kind_of?(Enumerable)
        raise Error, "Could not handle result: #{result.inspect}"
      end
      if result.kind_of?(Hash) && result['error']
        raise APIError, result['error'].to_s
      else
        structure result, block || target
      end
    end

    def service_url(name, params = {})
      url = BASE + name.to_s
      url.query = build_query(validate(params, API::VALIDATIONS[name]))
      url
    end

    def validate(params, against)
      Validation.run(params, against)
      params
    end

    def structure(value, target)
      case value
      when Array
        value.map{|r| structure(r, target) }
      when Hash
        if target.kind_of?(Proc)
          target.call(value)
        elsif target == Hash
          value
        else
          target.ancestors.include?(DataElement) ? target.new(self,value) : target.new(value)
        end
      else
        result
      end
    end

    def build_query(params)
      params.merge(api_params).map { |set|
        set.map { |i|
          CGI.escape(i.to_s)
        }.join('=')
      }.join('&')
    end

    def api_params
      @api_params ||= {key: @api_key, version: API::VERSION}
    end

  end

end
