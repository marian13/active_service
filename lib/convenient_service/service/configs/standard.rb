# frozen_string_literal: true

require_relative "standard/v1"
require_relative "standard/aliases"

module ConvenientService
  module Service
    module Configs
      ##
      # Default configuration for the user-defined services.
      #
      module Standard
        include Support::Concern

        ##
        # @internal
        #   IMPORTANT: Order of plugins matters.
        #
        #   NOTE: `class_exec` (that is used under the hood by `included`) defines `class Result` in the global namespace.
        #   That is why `class self::Result` is used.
        #   - https://stackoverflow.com/a/51965126/12201472
        #
        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Minimal

          concerns do
            use ConvenientService::Plugins::Common::CachesConstructorArguments::Concern
            use ConvenientService::Plugins::Common::CanBeCopied::Concern
            use ConvenientService::Plugins::Service::CanRecalculateResult::Concern
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Concern
            use ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern

            use ConvenientService::Plugins::Common::HasCallbacks::Concern
            use ConvenientService::Plugins::Common::HasAroundCallbacks::Concern

            use ConvenientService::Plugins::Service::HasNegatedResult::Concern
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Concern
            use ConvenientService::Plugins::Service::HasMermaidFlowchart::Concern
          end

          middlewares :initialize do
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            use ConvenientService::Plugins::Common::CachesConstructorArguments::Middleware
          end

          middlewares :result do
            insert_after \
              ConvenientService::Plugins::Common::NormalizesEnv::Middleware,
              ConvenientService::Plugins::Service::CollectsServicesInException::Middleware

            insert_before \
              ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Plugins::Common::HasCallbacks::Middleware

            insert_after \
              ConvenientService::Plugins::Common::HasCallbacks::Middleware,
              ConvenientService::Plugins::Common::HasAroundCallbacks::Middleware

            ##
            # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
            #
            # use ConvenientService::Plugins::Service::RaisesOnDoubleResult::Middleware

            insert_before \
              ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Plugins::Service::SetsParentToForeignResult::Middleware
          end

          ##
          # @internal
          #   NOTE: Check `Minimal` docs to understand why `use ConvenientService::Plugins::Common::NormalizesEnv::Middleware` for `:fallback_failure_result` is used in `Standard`, not in `Minimal` config.
          #
          middlewares :fallback_failure_result do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :failure)
          end

          ##
          # @internal
          #   NOTE: Check `Minimal` docs to understand why `use ConvenientService::Plugins::Common::NormalizesEnv::Middleware` for `:fallback_error_result` is used in `Standard`, not in `Minimal` config.
          #
          middlewares :fallback_error_result do
            use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :error)
          end

          middlewares :step do
            use ConvenientService::Plugins::Common::HasCallbacks::Middleware
            use ConvenientService::Plugins::Common::HasAroundCallbacks::Middleware
          end

          middlewares :success do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Success::Middleware
          end

          middlewares :failure do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Failure::Middleware
          end

          middlewares :error do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Error::Middleware
          end

          class self::Result
            concerns do
              use ConvenientService::Plugins::Common::HasJSendResultDuckShortSyntax::Concern
              use ConvenientService::Plugins::Result::CanRecalculateResult::Concern

              use ConvenientService::Plugins::Result::CanHaveStep::Concern
              use ConvenientService::Plugins::Result::CanBeNegated::Concern
              use ConvenientService::Plugins::Result::CanBeOwnResult::Concern
              use ConvenientService::Plugins::Result::CanHaveFallbacks::Concern
              use ConvenientService::Plugins::Result::CanHaveParentResult::Concern
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Concern
            end

            middlewares :success? do
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Middleware
            end

            middlewares :failure? do
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Middleware
            end

            middlewares :error? do
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Middleware
            end

            middlewares :not_success? do
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Middleware
            end

            middlewares :not_failure? do
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Middleware
            end

            middlewares :not_error? do
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Middleware
            end

            middlewares :data do
              use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
            end

            middlewares :message do
              use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
            end

            middlewares :code do
              use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
            end
          end

          class self::Step
            concerns do
              use ConvenientService::Plugins::Common::HasJSendResultDuckShortSyntax::Concern
              use ConvenientService::Plugins::Step::CanHaveFallbacks::Concern
            end

            middlewares :result do
              use ConvenientService::Plugins::Step::CanHaveFallbacks::Middleware.with(fallback_true_status: :failure)
              use ConvenientService::Plugins::Step::CanHaveParentResult::Middleware
            end

            middlewares :service_fallback_failure_result do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
              use ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware
            end

            middlewares :fallback_failure_result do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end

            middlewares :service_fallback_error_result do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
              use ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware
            end

            middlewares :fallback_error_result do
              use ConvenientService::Plugins::Common::NormalizesEnv::Middleware
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware
            end
          end

          if Dependencies.rspec.loaded?
            concerns do
              insert_before 0, ConvenientService::Plugins::Service::CanHaveStubbedResults::Concern
            end

            middlewares :result do
              insert_after \
                ConvenientService::Plugins::Common::NormalizesEnv::Middleware,
                ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware

              insert_before \
                ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware,
                ConvenientService::Plugins::Service::CountsStubbedResultsInvocations::Middleware
            end

            middlewares :result, scope: :class do
              insert_after \
                ConvenientService::Plugins::Common::NormalizesEnv::Middleware,
                ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware

              insert_before \
                ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware,
                ConvenientService::Plugins::Service::CountsStubbedResultsInvocations::Middleware
            end

            class self::Result
              concerns do
                use ConvenientService::Plugins::Result::CanBeStubbedResult::Concern
                use ConvenientService::Plugins::Result::HasStubbedResultInvocationsCounter::Concern
              end

              middlewares :initialize do
                insert_before \
                  ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Middleware,
                  ConvenientService::Plugins::Result::HasStubbedResultInvocationsCounter::Middleware
              end
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
