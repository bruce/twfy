module Twfy

  class Validation

    class ServiceArgumentError < ::ArgumentError; end

    def self.run(params = {}, against = {})
      new(params, against).check!
    end

    def initialize(params = {}, against = {})
      @params  = params
      @against = against
    end

    def check!
      unless missing.empty?
        raise ServiceArgumentError, "Missing required params #{missing.inspect}"
      end
      unless extra.empty?
        raise ServiceArgumentError, "Unknown params #{extra.inspect}"
      end
      check_one_required!
    end

    private

    def required
      @required ||= list(@against[:require])
    end

    def allowed
      @allowed ||= allowed_with_dependencies
    end

    def one_required
      @one_required ||= list(@against[:require_one_of])
    end

    def dependencies_allowed
      @dependencies_allowed ||= @against[:allow_dependencies] || {}
    end

    def allowed_with_dependencies
      base = list(@against[:allow])
      dependencies_allowed.each_with_object(base) do |(key, dependent_keys), memo|
        if provided.include?(key)
          memo.push(*list(dependent_keys))
        end
      end
    end

    def provided
      @provided ||= @params.keys.map(&:to_sym)
    end

    def list(candidate)
      Array(candidate).dup.compact
    end

    def missing
      @missing ||= required - provided
    end

    def extra
      @extra ||= provided - (required + allowed + one_required)
    end

    def check_one_required!
      count = one_required_count
      if count
        if count < 1
          raise ServiceArgumentError, "Need exactly one of #{one_required.inspect}"
        elsif count > 1
          raise ServiceArgumentError, "Only one of #{one_required.inspect} allowed"
        end
      end
    end

    def one_required_count
      if one_required.any?
        provided.select { |item| one_required.include?(item) }.size
      end
    end

  end

end
