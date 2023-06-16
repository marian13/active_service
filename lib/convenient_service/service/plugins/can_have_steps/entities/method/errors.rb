# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Errors
              class MethodHasNoOrganizer < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @return [void]
                #
                # @internal
                #   TODO: Introduce `Method#step` for more verbose message?
                #
                def initialize(method:)
                  message = <<~TEXT
                    Organizer for method `:#{method.name}` is NOT assigned yet.

                    Did you forget to set it?
                  TEXT

                  super(message)
                end
              end

              class InputMethodIsNotDefinedInContainer < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    `in` method `#{method.name}` is NOT defined in `#{container.klass}`.

                    Did you forget to define it?
                  TEXT

                  super(message)
                end
              end

              class OutputMethodIsDefinedInContainer < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    `out` method `#{method.name}` is already defined in `#{container.klass}`.

                    Did you forget to remove it?
                  TEXT

                  super(message)
                end
              end

              class AliasInputMethodIsNotDefinedInContainer < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    Alias `in` method `#{method.name}` is NOT defined in `#{container.klass}`.

                    Did you forget to define it?
                  TEXT

                  super(message)
                end
              end

              class AliasOutputMethodIsDefinedInContainer < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    Alias `out` method `#{method.name}` is already defined in `#{container.klass}`.

                    Did you forget to remove it?
                  TEXT

                  super(message)
                end
              end

              class OutputMethodProc < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    Procs are not allowed for `out` methods.
                  TEXT

                  super(message)
                end
              end

              class OutputMethodRawValue < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    Raw values are not allowed for `out` methods.
                  TEXT

                  super(message)
                end
              end

              class CallerCanNotCalculateReassignment < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @return [void]
                #
                def initialize(method:)
                  message = <<~TEXT
                    Method caller failed to calculate reassignment for `#{method.name}`.

                    Method callers can calculate only `in` methods, while reassignments are always `out` methods.
                  TEXT

                  super(message)
                end
              end

              class InputMethodReassignment < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    Reassignments are not allowed for `in` methods.
                  TEXT

                  super(message)
                end
              end

              class MethodIsNotInputMethod < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    Method `#{method.name}` is NOT an `in` method.
                  TEXT

                  super(message)
                end
              end

              class MethodIsNotOutputMethod < ::ConvenientService::Error
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize(method:, container:)
                  message = <<~TEXT
                    Method `#{method.name}` is NOT an `out` method.
                  TEXT

                  super(message)
                end
              end

              class NotCompletedStep < ::ConvenientService::Error
                ##
                # @param method_name [Symbol]
                # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                # @return [void]
                #
                def initialize(method_name:, step:)
                  message = <<~TEXT
                    `out` method `#{method_name}` is called before its corresponding step `#{step.printable_service}` is completed.

                    Maybe it makes sense to change the steps order?
                  TEXT

                  super(message)
                end
              end

              class NotExistingStepResultDataAttribute < ::ConvenientService::Error
                ##
                # @param key [Symbol]
                # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                # @return [void]
                #
                def initialize(key:, step:)
                  message = <<~TEXT
                    Step `#{step.printable_service}` result does NOT return `#{key}` data attribute.

                    Maybe there is a typo in `out` definition?

                    Or `success` of `#{step.printable_service}` accepts a wrong key?
                  TEXT

                  super(message)
                end
              end
            end
          end
        end
      end
    end
  end
end
