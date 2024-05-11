# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethod, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:other) { :foo }
      let(:options) { {direction: :input} }

      let(:casted) { described_class.call(other: other, options: options) }

      let(:factory) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethodFactory.call(other: other) }

      context "when `factory` is NOT castable" do
        before do
          allow(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethodFactory).to receive(:call).and_return(nil)
        end

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `factory` is castable" do
        before do
          allow(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethodFactory).to receive(:call).and_return(factory)
        end

        context "when `key` is NOT castable" do
          before do
            allow(factory).to receive(:create_key).and_return(nil)
          end

          it "returns `nil`" do
            expect(casted).to be_nil
          end
        end

        context "when `key` is castable" do
          context "when `name` is NOT castable" do
            before do
              allow(factory).to receive(:create_name).and_return(nil)
            end

            it "returns `nil`" do
              expect(casted).to be_nil
            end
          end

          context "when `name` is castable" do
            context "when `caller` is NOT castable" do
              before do
                allow(factory).to receive(:create_caller).and_return(nil)
              end

              it "returns `nil`" do
                expect(casted).to be_nil
              end
            end

            context "when `caller` is castable" do
              context "when `direction` is NOT castable" do
                before do
                  allow(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethodDirection).to receive(:call).and_return(nil)
                end

                it "returns `nil`" do
                  expect(casted).to be_nil
                end
              end

              context "when `direction` is castable" do
                let(:method) do
                  ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.new(
                    key: factory.create_key,
                    name: factory.create_name,
                    caller: factory.create_caller,
                    direction: ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethodDirection.call(other: other, options: options)
                  )
                end

                it "returns method" do
                  expect(casted).to eq(method)
                end
              end
            end
          end
        end
      end

      context "when `other` is method" do
        let(:other) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: :input) }

        it "returns its copy" do
          expect(casted).to eq(other.copy)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
