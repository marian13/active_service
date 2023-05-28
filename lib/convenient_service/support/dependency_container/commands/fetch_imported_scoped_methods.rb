# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class FetchImportedScopedMethods < Support::Command
          ##
          # @!attribute [r] importing_module
          #   @return [Module]
          #
          attr_reader :importing_module

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

          ##
          # @!attribute [r] block
          #   @return [Proc, nil]
          #
          attr_reader :block

          ##
          # @param importing_module [Module]
          # @param scope [Symbol]
          # @param prepend [Boolean]
          # @param block [Proc]
          # @return [void]
          #
          def initialize(importing_module:, scope:, prepend:, &block)
            @importing_module = importing_module
            @scope = scope
            @prepend = prepend
            @block = block
          end

          ##
          # @return [Module]
          #
          def call
            Utils::Module.fetch_own_const(importing_module, :"Imported#{imported_prefix}#{scoped_prefix}Methods", &block)
          end

          private

          ##
          # @return [String]
          #
          def imported_prefix
            prepend ? "Prepended" : "Included"
          end

          ##
          # @return [String]
          #
          def scoped_prefix
            case scope
            when Constants::INSTANCE_SCOPE then "Instance"
            when Constants::CLASS_SCOPE then "Class"
            end
          end
        end
      end
    end
  end
end
