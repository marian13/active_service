# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::AmazingPrintInspect do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Essential) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Service::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
            expect(service_class.concerns.to_a).to include(ConvenientService::Service::Plugins::HasAmazingPrintInspect::Concern)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
              expect(service_class::Result.concerns.to_a).to include(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAmazingPrintInspect::Concern)
            end
          end

          example_group "service result data" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
                expect(service_class::Result::Data.concerns.to_a).to include(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAmazingPrintInspect::Concern)
              end
            end
          end

          example_group "service result message" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
                expect(service_class::Result::Message.concerns.to_a).to include(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAmazingPrintInspect::Concern)
              end
            end
          end

          example_group "service result code" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
                expect(service_class::Result::Code.concerns.to_a).to include(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasAmazingPrintInspect::Concern)
              end
            end
          end

          example_group "service result status" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
                expect(service_class::Result::Status.concerns.to_a).to include(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAmazingPrintInspect::Concern)
              end
            end
          end
        end

        example_group "service step" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
              expect(service_class::Step.concerns.to_a).to include(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAmazingPrintInspect::Concern)
            end
          end
        end
      end
    end

    context "when included multiple times" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            include mod
          end
        end
      end

      ##
      # NOTE: Check the following discussion for details:
      # https://github.com/marian13/convenient_service/discussions/43
      #
      it "applies its `included` block only once" do
        expect(service_class.concerns.to_a.size).to eq(12)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
