# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  module Values
                    class WithCallingOriginal < Chainings::Values::Base
                      ##
                      # @return [Boolean]
                      #
                      def value
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
    end
  end
end
