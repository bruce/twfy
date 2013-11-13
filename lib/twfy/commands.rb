module Twfy
  module Commands

    def convert_url(params = {})
      service :convertURL, params do |value|
        URI.parse(value['url'])
      end
    end

    def constituency(params = {})
      service :getConstituency, params, Constituency
    end

    def constituencies(params = {})
      service :getConstituencies, params, Constituency
    end

    def mp(params = {})
      service :getMP, params, MP
    end

    def mp_info(params = {})
      service :getMPInfo, params
    end

    def mps(params = {})
      service :getMPs, params, MP
    end

    def lord(params = {})
      service :getLord, params
    end

    def lords(params = {})
      service :getLords, params
    end

    # Members of Legislative Assembly
    def mlas(params = {})
      service :getMLAs, params
    end

    # Member of Scottish parliament
    def msps(params = {})
      service :getMSPs, params
    end

    def geometry(params = {})
      service :getGeometry, params, Geometry
    end

    def committee(params = {})
      service :getCommittee, params
    end

    def debates(params = {})
      service :getDebates, params
    end

    def wrans(params = {})
      service :getWrans, params
    end

    def wms(params = {})
      service :getWMS, params
    end

    def comments(params = {})
      service :getComments, params
    end

  end
end
