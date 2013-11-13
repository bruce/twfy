module Twfy

  module API

    VERSION = '1.0.0'

    VALIDATIONS = {
      convertURL: {require: :url},
      getConstituency: {require: :postcode},
      getConstituencies: {allow: [:date, :search, :longitude, :latitude, :distance]},
      getMP: {allow: [:postcode, :constituency, :id, :always_return]},
      getMPInfo: {require: :id},
      getMPs: {allow: [:date, :party, :search]},
      getLord: {require: :id},
      getLords: {allow: [:date, :party, :search]},
      getMLAs: {allow: [:date, :party, :search]},
      getMSPs: {allow: [:date, :party, :search]},
      getGeometry: {allow: :name},
      getCommittee: {require: :name, allow: :date},
      getDebates: {
        require: :type,
        require_one_of: [:date, :person, :search, :gid],
        allow_dependencies: {
          search: [:order, :page, :num],
          person: [:order, :page, :num]
        }
      },
      getWrans: {
        require_one_of: [:date, :person, :search, :gid],
        allow_dependencies: {
          search: [:order, :page, :num],
          person: [:order, :page, :num]
        }
      },
      getWMS: {
        require_one_of: [:date, :person, :search, :gid],
        allow_dependencies: {
          search: [:order, :page, :num],
          person: [:order, :page, :num]
        }
      },
      getComments: {allow: [:date, :search, :user_id, :pid, :page, :num]}
    }

  end

end
