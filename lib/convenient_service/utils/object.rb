# frozen_string_literal: true

require_relative "object/resolve_type"

module ConvenientService
  module Utils
    module Object
      class << self
        ##
        # @example
        #   ConvenientService::Utils::Object.resolve_type("foo")
        #
        def resolve_type(...)
          ResolveType.call(...)
        end
      end
    end
  end
end