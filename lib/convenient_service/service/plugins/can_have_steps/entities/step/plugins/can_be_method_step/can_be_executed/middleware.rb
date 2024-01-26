# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module CanBeExecuted
                  class Middleware < MethodChainMiddleware
                    intended_for :result, entity: :step

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeResultStep::CanBeExecuted::Exceptions::MethodForStepIsNotDefined]
                    #
                    # @internal
                    #   NOTE: `kwargs` are intentionally NOT passed to `object.__send__(method)`, since all the corresponding methods are available inside `entity.organizer.__send__(entity.method)` body.
                    #
                    def next(...)
                      return chain.next(...) unless entity.method_step?

                      entity.organizer.__send__(entity.method)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
