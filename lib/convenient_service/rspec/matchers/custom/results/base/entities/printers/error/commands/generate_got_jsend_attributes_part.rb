# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              module Printers
                class Failure < Printers::Base
                  module Commands
                    class GenerateGotJsendAttributesPart < Support::Command
                      include Support::Delegate
                      include Support::DependencyContainer::Import

                      ##
                      # @api private
                      #
                      # @!attribute printer [r]
                      #   @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base]
                      #
                      attr_reader :printer

                      ##
                      # @api private
                      #
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      delegate :result, to: :printer

                      ##
                      # @api private
                      #
                      # @return [Symbol]
                      #
                      import :"constants.DEFAULT_ERROR_CODE", from: Service::Plugins::HasJSendResult::Container

                      ##
                      # @api private
                      #
                      # @param printer [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base]
                      # @return [void]
                      #
                      def initialize(printer:)
                        @printer = printer
                      end

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      def call
                        [status_part, message_part, code_part].reject(&:empty).join("\n")
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def status_part
                        "with `error` status"
                      end

                      ##
                      # @return [String]
                      #
                      def message_part
                        message.empty? ? "without message" : "with message `#{message}`"
                      end

                      ##
                      # @return [String]
                      #
                      def code_part
                        return "" if code == constants.DEFAULT_ERROR_CODE

                        "with code `#{code}`"
                      end

                      ##
                      # @return [String]
                      #
                      def message
                        @message ||= result.unsafe_message.to_s
                      end

                      ##
                      # @return [Symbol]
                      #
                      def code
                        @code ||= result.unsafe_code.to_sym
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
