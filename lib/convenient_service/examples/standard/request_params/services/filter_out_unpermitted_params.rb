# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Services
          class FilterOutUnpermittedParams
            include ConvenientService::Standard::Config

            attr_reader :params, :permitted_keys

            def initialize(params:, permitted_keys:)
              @params = params
              @permitted_keys = permitted_keys
            end

            def result
              # byebug

              success(params: params.slice(*permitted_keys))
            end
          end
        end
      end
    end
  end
end