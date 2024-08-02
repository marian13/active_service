# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        module Entities
          class Type
            module Concern
              include Support::Concern

              class_methods do
                ##
                # @param other [Object] Can be any type.
                # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type, nil]
                #
                def cast(other)
                  case other
                  when ::Symbol
                    Type.new(value: other)
                  when ::String
                    Type.new(value: other.to_sym)
                  when Type
                    Type.new(value: other.value)
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
