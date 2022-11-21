# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultMethodSteps::Services::MethodStepConfig do
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

      specify { expect(service_class).to include_module(ConvenientService::Core) }

      example_group "service" do
        it "adds concerns" do
          expect(service_class.concerns.to_a.last(1)).to eq([
            ConvenientService::Service::Plugins::HasResult::Concern
          ])
        end

        it "adds middlewares for `result`" do
          expect(service_class.middlewares(:result).to_a.last(1)).to eq([
            ConvenientService::Service::Plugins::HasResult::Middleware
          ])
        end

        example_group "service result" do
          it "sets service result concerns" do
            expect(service_class::Result.concerns.to_a).to eq([
              ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
            ])
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
