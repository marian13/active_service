# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanHaveCheckedStatus
                class Middleware < MethodChainMiddleware
                  intended_for [
                    :success?,
                    :failure?,
                    :error?,
                    :not_success?,
                    :not_failure?,
                    :not_error?
                  ],
                    entity: :result

                  ##
                  # @param args [Array<Object>]
                  # @param kwargs [Hash{Symbol => Object}]
                  # @param block [Proc, nil]
                  # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                  #
                  def next(*args, **kwargs, &block)
                    mark_status_as_checked = kwargs.fetch(:mark_status_as_checked) { true }

                    entity.internals.cache[:has_checked_status] = true if mark_status_as_checked

                    chain.next(*args, **Utils::Hash.except(kwargs, [:mark_status_as_checked]), &block)
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