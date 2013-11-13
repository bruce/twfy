require 'cgi'
require 'logger'
require 'multi_json'
require 'open-uri'
require 'ostruct'

module Twfy

  class Client

    class Error < ::StandardError; end
    class APIError < ::StandardError; end

    def initialize(api_key, log_to=$stderr)
      @api_key = api_key
      @logger = Logger.new(log_to)
    end

    def log(message, level=:info)
      @logger.send(level, message) if $DEBUG
    end

    def convert_url(params = {})
      service :convertURL, validate(params, require: :url) do |value|
        URI.parse(value['url'])
      end
    end

    def constituency(params = {})
      service :getConstituency, validate(params,
                                         require: :postcode), Constituency
    end

    def constituencies(params = {})
      service :getConstituencies, validate(params,
                                           allow: [:date, :search, :longitude, :latitude, :distance]), Constituency
    end

    def mp(params = {})
      service :getMP, validate(params,
                               allow: [:postcode, :constituency, :id, :always_return]), MP
    end

    def mp_info(params = {})
      service :getMPInfo, validate(params, require: :id)
    end

    def mps(params = {})
      service :getMPs, validate(params, allow: [:date, :party, :search]), MP
    end

    def lord(params = {})
      service :getLord, validate(params, require: :id)
    end

    def lords(params = {})
      service :getLords, validate(params, allow: [:date, :party, :search])
    end

    # Members of Legislative Assembly
    def mlas(params = {})
      service :getMLAs, validate(params, allow: [:date, :party, :search])
    end

    # Member of Scottish parliament
    def msps(params = {})
      service :getMSPs, validate(params, allow: [:date, :party, :search])
    end

    def geometry(params = {})
      service :getGeometry, validate(params, allow: :name), Geometry
    end

    def committee(params = {})
      service :getCommittee, validate(params, require: :name, allow: :date)
    end

    def debates(params = {})
      service :getDebates, validate(params,
                                    require: :type,
                                    require_one_of: [:date, :person, :search, :gid],
                                    allow_dependencies: {
                                      search: [:order, :page, :num],
                                      person: [:order, :page, :num]
                                    })
    end


    def wrans(params = {})
      service :getWrans, validate(params,
                                  require_one_of: [:date, :person, :search, :gid],
                                  allow_dependencies: {
                                    search: [:order, :page, :num],
                                    person: [:order, :page, :num]
                                  } )
    end

    def wms(params = {})
      service :getWMS, validate(params,
                                require_one_of: [:date, :person, :search, :gid],
                                allow_dependencies: {
                                  search: [:order, :page, :num],
                                  person: [:order, :page, :num]
                                } )
    end

    def comments(params = {})
      service :getComments, validate(params,
                                     allow: [:date, :search, :user_id, :pid, :page, :num])
    end

    def service(name, params = {}, target = OpenStruct, &block)
      log "Calling service #{name}"
      url = BASE + name.to_s
      url.query = build_query(params)
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

    private

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
      params.update(:key=>@api_key, :version=>API_VERSION)
      params.map{|set| set.map{|i| CGI.escape(i.to_s)}.join('=') }.join('&')
    end

  end

end
