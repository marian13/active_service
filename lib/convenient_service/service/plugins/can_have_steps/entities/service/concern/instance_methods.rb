# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Service
            module Concern
              module InstanceMethods
                include Support::Delegate

                ##
                # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                #
                delegate :result, to: :klass

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                #
                delegate :step_class, to: :klass

                ##
                # @!attribute [r] klass
                #   @return [Class]
                #
                attr_reader :klass

                ##
                # @param klass [Class]
                #
                def initialize(klass)
                  @klass = klass
                end

                ##
                # @return [Mutex]
                #
                def mutex
                  klass.__convenient_service_config__.mutex
                end

                ##
                # @param method [String, Symbol]
                # @return [Boolean]
                #
                def has_defined_method?(method)
                  Utils::Method.defined?(method, klass, private: true)
                end

                ##
                # @param other [Object] Can be any type.
                # @return [Boolean, nil]
                #
                def ==(other)
                  casted = cast(other)

                  return unless casted

                  return false if klass != casted.klass

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end
