# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [Array<ConvenientService::Service::Plugins::HasResultSteps::Entities::Step>]
            #
            def steps
              internals.cache.fetch(:steps) do
                self.class
                  .steps
                  .tap(&:commit!)
                  .map { |step| step.copy(overrides: {kwargs: {organizer: self}}) }
              end
            end

            ##
            # Returns step by index.
            # Returns `nil` when index is out of range.
            #
            # @param index [Integer]
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
            #
            # @note This method was initially designed as a hook (callback trigger).
            # @see ConvenientService::Service::Plugins::HasResultSteps::Middleware#next
            #
            def step(index)
              steps[index]
            end
          end

          class_methods do
            ##
            # Registers a step (step definition).
            #
            # @param args [Array]
            # @param kwargs [Hash]
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
            #
            def step(*args, **kwargs)
              step_class.new(*args, **kwargs.merge(container: self))
                .tap { |step_instance| steps << step_instance }
            end

            ##
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Support::RawValue]
            #
            # Allows to pass a value to `in` method without its intermediate processing.
            # @see https://marian13.github.io/convenient_service_docs/basics/step_to_result_translation_table
            #
            # @example `:chat_v2` is passed to `AssertFeatureEnabled` as it is.
            #   step AssertFeatureEnabled, in: {name: raw(:chat_v2)}
            #   # that is converted to the following service invocation:
            #   AssertFeatureEnabled.result(name: :chat_v2)
            #
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Support::RawValue]
            #
            def raw(value)
              Support::RawValue.wrap(value)
            end

            ##
            # @param method_name [String, Symbol]
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Values::Reassignment]
            #
            def reassign(method_name)
              Entities::Method::Entities::Values::Reassignment.new(method_name)
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::StepCollection]
            #
            def steps
              @steps ||= Entities::StepCollection.new
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
            #
            def step_class
              @step_class ||= Commands::CreateStepClass.call(service_class: self)
            end
          end
        end
      end
    end
  end
end
