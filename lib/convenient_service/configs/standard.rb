# frozen_string_literal: true

module ConvenientService
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
          use Plugins::Common::CachesConstructorArguments::Concern
          use Plugins::Common::CanBeCopied::Concern
          use Plugins::Service::CanRecalculateResult::Concern
          use Plugins::Service::HasResultShortSyntax::Concern
          use Plugins::Service::HasResultStatusCheckShortSyntax::Concern

          use Plugins::Common::HasCallbacks::Concern
          use Plugins::Common::HasAroundCallbacks::Concern

          use Plugins::Service::CanBeTried::Concern
        end

        middlewares :initialize do
          use Plugins::Service::CollectsServicesInException::Middleware
          use Plugins::Common::CachesConstructorArguments::Middleware
        end

        middlewares :result do
          insert_after \
            Plugins::Common::NormalizesEnv::Middleware,
            Plugins::Service::CollectsServicesInException::Middleware

          insert_before \
            Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
            Plugins::Common::HasCallbacks::Middleware

          insert_after \
            Plugins::Common::HasCallbacks::Middleware,
            Plugins::Common::HasAroundCallbacks::Middleware

          ##
          # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
          #
          # use Plugins::Service::RaisesOnDoubleResult::Middleware

          insert_before \
            Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
            Plugins::Service::SetsParentToForeignResult::Middleware
        end

        ##
        # @internal
        #   NOTE: Check `Minimal` docs to understand why `use Plugins::Common::NormalizesEnv::Middleware` for `:try_result` is used in `Standard`, not in `Minimal` config.
        #
        middlewares :try_result do
          use Plugins::Common::NormalizesEnv::Middleware
          use Plugins::Service::CollectsServicesInException::Middleware
          use Plugins::Common::CachesReturnValue::Middleware

          use Plugins::Service::RaisesOnNotResultReturnValue::Middleware
          use Plugins::Service::CanBeTried::Middleware
        end

        middlewares :step do
          use Plugins::Common::HasCallbacks::Middleware
          use Plugins::Common::HasAroundCallbacks::Middleware
        end

        middlewares :success do
          use Plugins::Service::HasResultShortSyntax::Success::Middleware
        end

        middlewares :failure do
          use Plugins::Service::HasResultShortSyntax::Failure::Middleware
        end

        middlewares :error do
          use Plugins::Service::HasResultShortSyntax::Error::Middleware
        end

        class self::Result
          concerns do
            use Plugins::Common::HasResultDuckShortSyntax::Concern
            use Plugins::Result::CanRecalculateResult::Concern

            use Plugins::Result::CanHaveStep::Concern
            use Plugins::Result::CanBeOwnResult::Concern
            use Plugins::Result::CanBeTried::Concern
            use Plugins::Result::CanHaveParentResult::Concern
            use Plugins::Result::CanHaveCheckedStatus::Concern
          end

          middlewares :success? do
            use Plugins::Result::CanHaveCheckedStatus::Middleware
          end

          middlewares :failure? do
            use Plugins::Result::CanHaveCheckedStatus::Middleware
          end

          middlewares :error? do
            use Plugins::Result::CanHaveCheckedStatus::Middleware
          end

          middlewares :not_success? do
            use Plugins::Result::CanHaveCheckedStatus::Middleware
          end

          middlewares :not_failure? do
            use Plugins::Result::CanHaveCheckedStatus::Middleware
          end

          middlewares :not_error? do
            use Plugins::Result::CanHaveCheckedStatus::Middleware
          end

          middlewares :data do
            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares :message do
            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares :code do
            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end
        end

        class self::Step
          concerns do
            use Plugins::Common::HasResultDuckShortSyntax::Concern
            use Plugins::Step::CanBeTried::Concern
          end

          middlewares :result do
            use Plugins::Step::CanBeTried::Middleware
            use Plugins::Step::CanHaveParentResult::Middleware
          end

          middlewares :service_try_result do
            use Plugins::Common::NormalizesEnv::Middleware
            use Plugins::Common::CachesReturnValue::Middleware
          end

          middlewares :try_result do
            use Plugins::Common::NormalizesEnv::Middleware
            use Plugins::Common::CachesReturnValue::Middleware
          end
        end

        if Dependencies.rspec.loaded?
          concerns do
            insert_before 0, Plugins::Service::CanHaveStubbedResults::Concern
          end

          middlewares :result do
            insert_after \
              Plugins::Common::NormalizesEnv::Middleware,
              Plugins::Service::CanHaveStubbedResults::Middleware

            insert_before \
              Plugins::Service::CanHaveStubbedResults::Middleware,
              Plugins::Service::CountsStubbedResultsInvocations::Middleware
          end

          middlewares :result, scope: :class do
            insert_after \
              Plugins::Common::NormalizesEnv::Middleware,
              Plugins::Service::CanHaveStubbedResults::Middleware

            insert_before \
              Plugins::Service::CanHaveStubbedResults::Middleware,
              Plugins::Service::CountsStubbedResultsInvocations::Middleware
          end

          class self::Result
            concerns do
              use Plugins::Result::CanBeStubbedResult::Concern
              use Plugins::Result::HasStubbedResultInvocationsCounter::Concern
            end

            middlewares :initialize do
              insert_before \
                Plugins::Result::HasJSendStatusAndAttributes::Middleware,
                Plugins::Result::HasStubbedResultInvocationsCounter::Middleware
            end
          end
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
    end
  end
end
