# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeError < Results::Base
            ##
            # @api private
            #
            # @return [Array<Symbol>]
            #
            def statuses
              [Service::Plugins::HasJSendResult::Constants::ERROR_STATUS]
            end
          end
        end
      end
    end
  end
end
