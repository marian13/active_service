# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Entities
                  class Status
                    module Concern
                      module ClassMethods
                        ##
                        # @param other [Object] Can be any type.
                        # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Status, nil]
                        #
                        def cast(other)
                          case other
                          when ::String
                            new(value: other.to_sym)
                          when ::Symbol
                            new(value: other)
                          when Status
                            new(value: other.value)
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
  end
end
