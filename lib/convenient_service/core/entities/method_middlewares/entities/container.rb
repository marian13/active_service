# frozen_string_literal: true

require_relative "container/commands"

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            ##
            # @!attribute [r] service_class
            #   @return [Class]
            #
            attr_reader :service_class

            ##
            # @param service_class [Class]
            # @return [void]
            #
            def initialize(service_class:)
              @service_class = service_class
            end

            ##
            # @param scope [:instance, :class]
            # @param method [Symbol]
            # @return [Boolean]
            #
            def define_method_middlewares_caller!(scope, method)
              Commands::DefineMethodMiddlewaresCaller.call(scope: scope, method: method, container: self)
            end

            ##
            # @param scope [:instance, :class]
            # @return [Module]
            #
            def resolve_methods_middlewares_callers(scope)
              Commands::ResolveMethodsMiddlewaresCallers.call(scope: scope, container: self)
            end

            ##
            # @param other [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container, Object]
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if service_class != other.service_class

              true
            end
          end
        end
      end
    end
  end
end
