# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
                    module Concern
                      module InstanceMethods
                        ##
                        # @!attribute [r] value
                        #   @return [Hash]
                        #
                        attr_reader :value

                        ##
                        # @param value [Hash]
                        # @return [void]
                        #
                        # @internal
                        #   NOTE: Ruby hashes enumerate their values in the order that the corresponding keys were inserted.
                        #   That is why the end-user can be 100% sure that the failure message is always generated from the first key/value pair.
                        #   - https://ruby-doc.org/core-2.7.0/Hash.html
                        #
                        #   TODO: A test that crashes when such behaviour is broken.
                        #
                        #   NOTE: As a result, there is NO need to use any custom `OrderedHash` implementations.
                        #   - https://api.rubyonrails.org/v5.1/classes/ActiveSupport/OrderedHash.html
                        #   - https://github.com/rails/rails/issues/22681
                        #   - https://api.rubyonrails.org/classes/ActiveSupport/OrderedOptions.html
                        #
                        def initialize(value:)
                          @value = value
                        end

                        ##
                        # @param key [String, Symbol]
                        # @return [Boolean]
                        #
                        def has_attribute?(key)
                          value.has_key?(key.to_sym)
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        def ==(other)
                          casted = cast(other)

                          return unless casted

                          value == casted.value
                        end

                        ##
                        # @param key [String, Symbol]
                        # @return [Object] Can be any type.
                        # @raise [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Errors::NotExistingAttribute]
                        #
                        def [](key)
                          value.fetch(key.to_sym) { raise Errors::NotExistingAttribute.new(attribute: key) }
                        end

                        ##
                        # @return [Hash]
                        #
                        def to_h
                          @to_h ||= value.to_h
                        end

                        ##
                        # @return [String]
                        #
                        def to_s
                          @to_s ||= to_h.to_s
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