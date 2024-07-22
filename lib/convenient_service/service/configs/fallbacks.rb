# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Fallbacks
        include Support::Concern

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          middlewares :fallback_failure_result do
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :failure)
          end

          middlewares :fallback_error_result do
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :error)
          end

          middlewares :fallback_result do
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware

            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: nil)
          end

          class self::Result
            concerns do
              use ConvenientService::Plugins::Result::CanHaveFallbacks::Concern
            end
          end

          class self::Step
            concerns do
              use ConvenientService::Plugins::Step::CanHaveFallbacks::Concern
            end

            middlewares :result do
              insert_after \
                ConvenientService::Plugins::Step::HasResult::Middleware,
                ConvenientService::Plugins::Step::CanHaveFallbacks::Middleware.with(fallback_true_status: :failure)
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end