# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallback
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # Returns `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result` when overridden.
            #
            # @raise [ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::FallbackResultIsNotOverridden]
            #
            # @internal
            #   NOTE: name is inspired by Ruby's `fallback_convert` methods.
            #   - https://blog.saeloun.com/2021/08/03/ruby-adds-integer-try-convert
            #
            #   TODO: A plugin that checks that a `success` is returned from `fallback_result`.
            #
            def fallback_result
              raise Exceptions::FallbackResultIsNotOverridden.new(service: self)
            end
          end

          class_methods do
            ##
            # Returns `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result` when `#fallback_result` is overridden.
            #
            # @raise [ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::FallbackResultIsNotOverridden]
            #
            # @example `fallback_result` method MUST always return `success` with reasonable "null" data.
            #
            #   For example, check the following service:
            #
            #     class SelectActiveUsers
            #       include ConvenientService::Standard::Config
            #
            #       # ...
            #
            #       def result
            #         # ...
            #
            #         success(users: ::User.where(active: true))
            #       end
            #
            #       # ...
            #     end
            #
            #   Since `result` returns relation for `users` when it is successful, its corresponding `fallback_result` must also return a relation.
            #
            #     class SelectActiveUsers
            #       include ConvenientService::Standard::Config
            #
            #       # ...
            #
            #       def fallback_result
            #         # ...
            #
            #         success(users: ::User.none)
            #       end
            #
            #       # ...
            #     end
            #
            #   This way a significant amount of extra `if` statements can be avoided.
            #
            #   result = SelectActiveUsers.result # or `result = SelectActiveUsers.fallback_result`
            #
            #   if result.success?
            #     result.data[:users].count
            #   end
            #
            #   It is safe to invoke `count` for both `result` and `fallback_result` since `result.data[:users]` return same class.
            #
            #   This idea can be applied in a broader sense by utilizing the Null object pattern.
            #
            # @see https://thoughtbot.com/blog/rails-refactoring-example-introduce-null-object
            # @see https://en.wikipedia.org/wiki/Null_object_pattern
            #
            # @internal
            #   TODO: Is it necessary to use `SetsParentToForeignResult` for `fallback_result`?
            #
            def fallback_result(...)
              new(...).fallback_result
            end
          end
        end
      end
    end
  end
end