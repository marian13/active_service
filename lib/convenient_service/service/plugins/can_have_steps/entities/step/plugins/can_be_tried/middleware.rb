# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeTried
                class Middleware < MethodChainMiddleware
                  intended_for :result, entity: :step

                  ##
                  # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                  #
                  # @internal
                  #   NOTE: `result.copy` is used to return a fresh result, with unchecked status.
                  #
                  def next(...)
                    result = chain.next(...)

                    return result unless entity.try_step?

                    return result.copy if result.success?

                    entity.try_result(...)
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