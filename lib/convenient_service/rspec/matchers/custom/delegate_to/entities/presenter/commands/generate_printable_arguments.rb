# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Presenter
              module Commands
                class GeneratePrintableArguments < Support::Command
                  include Support::Delegate

                  ##
                  # @!attribute [r] arguments
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments]
                  #
                  attr_reader :arguments

                  ##
                  # @return [Array]
                  #
                  delegate :args, to: :arguments

                  ##
                  # @return [Hash]
                  #
                  delegate :kwargs, to: :arguments

                  ##
                  # @return [Proc]
                  #
                  delegate :block, to: :arguments

                  ##
                  # @param arguments [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Arguments]
                  #
                  def initialize(arguments:)
                    @arguments = arguments
                  end

                  ##
                  # @return [String]
                  #
                  def call
                    text =
                      if args.any? && kwargs.any?
                        "(#{printable_args}, #{printable_kwargs})"
                      elsif args.any?
                        "(#{printable_args})"
                      elsif kwargs.any?
                        "(#{printable_kwargs})"
                      else
                        "()"
                      end

                    text += " #{printable_block}" if block

                    text
                  end

                  ##
                  # @return [String]
                  #
                  def printable_args
                    args.map(&:inspect).join(", ")
                  end

                  ##
                  # @return [String]
                  #
                  def printable_kwargs
                    kwargs.map { |key, value| "#{key}: #{value.inspect}" }.join(", ")
                  end

                  ##
                  # @return [String]
                  #
                  # @internal
                  #   TODO: Generic util to print blocks.
                  #
                  def printable_block
                    block ? "{ ... }" : ""
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
