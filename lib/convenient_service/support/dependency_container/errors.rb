# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Errors
        class NotExportableModule < ConvenientService::Error
          ##
          # @param mod [Module]
          # @return [void]
          #
          def initialize(mod:)
            message = <<~TEXT
              Module `#{mod}` can NOT export methods.

              Did you forget to include `ConvenientService::Container.export` into it?
            TEXT

            super(message)
          end
        end

        class NotExportedMethod < ConvenientService::Error
          ##
          # @param method_name [String]
          # @param method_scope [Symbol]
          # @param mod [Module]
          # @return [void]
          #
          def initialize(method_name:, method_scope:, mod:)
            message = <<~TEXT
              Module `#{mod}` does NOT export method `#{method_name}` with `#{method_scope}` scope.

              Did you forget to export if from `#{mod}`? For example:

              module #{mod}
                export #{method_name}, scope: :#{method_scope} do |*args, **kwargs, &block|
                  # ...
                end
              end
            TEXT

            super(message)
          end
        end
      end
    end
  end
end