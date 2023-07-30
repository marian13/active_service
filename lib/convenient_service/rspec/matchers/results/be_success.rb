# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeSuccess
          ##
          # @api public
          #
          def be_success(...)
            Custom::Results::BeSuccess.new(...)
          end
        end
      end
    end
  end
end
