# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          ##
          # https://github.com/Ibsciss/ruby-middleware#a-basic-example
          #
          # NOTE: Do NOT pollute the interface of this class until really needed. Avoid even pollution of private methods.
          #
          class Middleware
            def initialize(stack)
              @stack = stack
            end

            def call(env)
              @env = env

              ##
              # IMPORTANT: This is a library code. Do NOT do things like this in your application code.
              #
              chain.instance_variable_set(:@env, env)

              ##
              # TODO: Enforce to always pass args, kwargs, block.
              #
              __send__(:next, *env[:args], **env[:kwargs], &env[:block])
            end

            ##
            # NOTE: `@env` is set inside `call`.
            #
            def entity
              @env[:entity]
            end

            ##
            # NOTE: `@env` is set inside `call`.
            #
            def method
              @env[:method]
            end

            ##
            # NOTE: `@env` is set inside `call`.
            #
            def chain
              @chain ||= Entities::Chain.new(stack: @stack)
            end
          end
        end
      end
    end
  end
end
