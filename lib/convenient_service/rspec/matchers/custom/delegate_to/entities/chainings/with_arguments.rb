# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            module Chainings
              class WithArguments
                ##
                # @internal
                #   NOTE: `include ::RSpec::Mocks::ExampleMethods`.
                #   - https://github.com/rspec/rspec-mocks/blob/v3.11.1/lib/rspec/mocks/example_methods.rb
                #   - https://github.com/rspec/rspec-mocks/blob/main/lib/rspec/mocks/example_methods.rb
                #
                include ::RSpec::Mocks::ExampleMethods

                include Support::Delegate

                ##
                # @!attribute [r] matcher
                #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                attr_reader :matcher

                ##
                # @return [Object]
                #
                attr_reader :block_expectation_value

                ##
                # @return [Object]
                #
                delegate :object, to: :matcher

                ##
                # @return [String, Symbol]
                #
                delegate :method, to: :matcher

                ##
                # @return [Array]
                #
                delegate :expected_arguments, to: :matcher

                ##
                # @return [Array]
                #
                delegate :delegations, to: :matcher

                ##
                # @return [String]
                #
                delegate :printable_actual_arguments, to: :matcher

                ##
                # @return [String]
                #
                delegate :printable_block_expectation, to: :matcher

                ##
                # @return [String]
                #
                delegate :printable_method, to: :matcher

                ##
                # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                # @return [void]
                #
                def initialize(matcher:)
                  @matcher = matcher
                end

                ##
                # @return [void]
                #
                def apply_mocks!
                  ##
                  # NOTE: RSpec `allow(object).to receive(method).with(*args, **kwargs)` does NOT support block.
                  # https://github.com/rspec/rspec-mocks/issues/1182#issuecomment-679820352
                  #
                  # NOTE: RSpec `allow(object).to receive(method) do` does NOT support `and_call_original`.
                  # https://github.com/rspec/rspec-mocks/issues/774#issuecomment-54245277
                  #
                  # NOTE: That is why `and_wrap_original` is used.
                  # https://relishapp.com/rspec/rspec-mocks/docs/configuring-responses/wrapping-the-original-implementation
                  #
                  allow(object).to receive(method).and_wrap_original do |original, *actual_args, **actual_kwargs, &actual_block|
                    ##
                    # TODO: Add backtrace for easier reason tracing.
                    #
                    delegations << Entities::Delegation.new(args: actual_args, kwargs: actual_kwargs, block: actual_block)

                    ##
                    # NOTE: Imitates `and_call_original`.
                    #
                    original.call(*actual_args, **actual_kwargs, &actual_block)
                  end
                end

                ##
                # @param block_expectation_value [Object]
                # @return [Boolean]
                #
                def matches?(block_expectation_value)
                  @block_expectation_value = block_expectation_value

                  ##
                  # IMPORTANT: A matcher should always return a boolean.
                  # https://github.com/zverok/saharspec/blob/master/lib/saharspec/matchers/send_message.rb#L59
                  #
                  # NOTE: RSpec raises exception when any `expect` is NOT satisfied.
                  # So, this `true` is returned only when all `expect` are successful.
                  #
                  delegations.any? { |delegation| delegation.arguments == expected_arguments }
                end

                ##
                # @param block_expectation_value [Object]
                # @return [Boolean]
                #
                def does_not_match?(block_expectation_value)
                  !matches?(block_expectation_value)
                end

                ##
                # @return [String]
                #
                def failure_message
                  <<~MESSAGE
                    #{failure_message_expected_part}

                    #{failure_message_got_part}
                  MESSAGE
                end

                ##
                # @return [String]
                #
                def failure_message_when_negated
                  "expected `#{printable_block_expectation}` NOT to delegate to `#{printable_method}` with `#{printable_expected_arguments}` at least once, but it did."
                end

                private

                def failure_message_expected_part
                  "expected `#{printable_block_expectation}` to delegate to `#{printable_method}` with `#{printable_expected_arguments}` at least once, but it didn't."
                end

                ##
                # @return [String]
                #
                # @internal
                #   TODO: String diff.
                #
                def failure_message_got_part
                  if delegations.empty?
                    "got not delegated at all"
                  else
                    "got delegated with #{printable_actual_arguments}"
                  end
                end

                def printable_expected_arguments
                  Commands::GeneratePrintableArguments.call(arguments: expected_arguments)
                end
              end
            end
          end
        end
      end
    end
  end
end