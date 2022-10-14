# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Commands::CreateStepClass do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::BeDescendantOf
      include ConvenientService::RSpec::Matchers::IncludeModule

      subject(:command_result) { described_class.call(service_class: service_class) }

      let(:service_class) { Class.new }

      context "when `service_class` does NOT have it own `Step`" do
        let(:service_class) { Class.new }

        it "returns `Class` instance" do
          expect(command_result).to be_instance_of(Class)
        end

        it "returns `ConvenientService::Service::Plugins::HasResultSteps::Entities::Step` descendant" do
          expect(command_result).to be_descendant_of(ConvenientService::Service::Plugins::HasResultSteps::Entities::Step)
        end

        it "includes `ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Concern`" do
          expect(command_result).to include_module(ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Concern)
        end
      end

      context "when `service_class` has its own `Step`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.const_set(:Step, Class.new)
          end
        end

        it "returns `Class` instance" do
          expect(command_result).to be_instance_of(Class)
        end

        it "returns that own `Step`" do
          expect(command_result).to eq(service_class::Step)
        end

        it "includes `ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Concern`" do
          expect(command_result).to include_module(ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Concern)
        end
      end

      example_group "step class" do
        let(:step_class) { described_class.call(service_class: service_class) }

        example_group "class methods" do
          describe ".service_class" do
            it "returns `service_class` passed to `ConvenientService::Service::Plugins::HasResultSteps::Commands::CreateStepClass`" do
              expect(step_class.service_class).to eq(service_class)
            end
          end

          describe ".==" do
            context "when `other` has different class" do
              let(:other) { 42 }

              it "returns `false`" do
                expect(step_class == other).to be_nil
              end
            end

            context "when `other` has different `service_class`" do
              let(:other) { described_class.call(service_class: Class.new) }

              it "returns `false`" do
                expect(step_class == other).to eq(false)
              end
            end

            context "when `other` has same attributes" do
              let(:other) { described_class.call(service_class: service_class) }

              it "returns `true`" do
                expect(step_class == other).to eq(true)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
