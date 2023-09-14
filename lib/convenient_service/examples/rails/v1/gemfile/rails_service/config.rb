# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Rails::V1::Gemfile.format(path: "Gemfile")
# result = ConvenientService::Examples::Rails::V1::Gemfile.format(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Rails
      module V1
        class Gemfile
          class RailsService
            module Config
              include Support::Concern

              included do
                include ConvenientService::Standard::V1::Config

                ##
                # NOTE: `AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment` plugin.
                #
                concerns do
                  use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern
                end

                middlewares :initialize do
                  use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
                end

                ##
                # NOTE: `HasAttributes::UsingActiveModelAttributes` plugin.
                #
                concerns do
                  use ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern
                end

                ##
                # NOTE: `HasJSendResultParamsValidations::UsingActiveModelValidations` plugin.
                #
                concerns do
                  use ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern
                end

                middlewares :result do
                  insert_before \
                    ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware,
                    ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware.with(status: :failure)
                end
              end
            end
          end
        end
      end
    end
  end
end
