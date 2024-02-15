# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanHaveCheckedStatus
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def checked?
                      status.checked?
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
