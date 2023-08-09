# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Exceptions
          class ResultIsNotOverridden < ::ConvenientService::Exception
            def initialize(service:)
              message = <<~TEXT
                Result method (#result) of `#{service.class}` is NOT overridden.
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
