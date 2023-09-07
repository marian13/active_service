# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallback
        module Exceptions
          class FallbackResultIsNotOverridden < ::ConvenientService::Exception
            def initialize(service:, status:)
              message = <<~TEXT
                Fallback #{status} result method (#fallback_#{status}_result) of `#{service.class}` is NOT overridden.

                NOTE: Make sure overridden `fallback_#{status}_result` returns `success` with reasonable "null" data.
              TEXT

              super(message)
            end
          end

          class ServiceFallbackReturnValueNotSuccess < ::ConvenientService::Exception
            def initialize(service:, result:, status:)
              message = <<~TEXT
                Return value of service `#{service.class}` `#{status}` fallback is NOT a `success`.
                It is `#{result.status}`.

                Did you accidentally call `failure` or `error` instead of `success` from the `fallback_#{status}_result` method?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
