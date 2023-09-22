# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec do
  include ConvenientService::RSpec::Matchers::Results

  let(:result_spec) { described_class.new(status: status, service_class: service_class, chain: chain) }

  let(:status) { :success }
  let(:chain) { {} }

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Standard

      def result
        success
      end
    end
  end

  example_group "class methods" do
    describe ".new" do
      context "when service class is NOT passed" do
        it "defaults to `nil`" do
          expect(described_class.new(status: status, chain: chain)).to eq(described_class.new(status: status, service_class: nil, chain: chain))
        end
      end

      context "when chain is NOT passed" do
        it "defaults to empty hash" do
          expect(described_class.new(status: status, service_class: service_class)).to eq(described_class.new(status: status, service_class: service_class, chain: {}))
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#for" do
      let(:other_service_class) { Class.new }

      it "returns result copy with passed service class" do
        expect(result_spec.for(other_service_class)).to eq(described_class.new(status: status, service_class: other_service_class, chain: chain))
      end
    end

    describe "#calculate_value" do
      context "when result spec for failure" do
        let(:result_spec) { described_class.new(status: :failure, service_class: service_class) }

        it "returns failure" do
          expect(result_spec.calculate_value).to be_failure
        end

        it "returns stubbed result" do
          expect(result_spec.calculate_value.stubbed_result?).to eq(true)
        end

        context "when result spec for failure with data" do
          let(:result_spec) { described_class.new(status: :failure, service_class: service_class).with_data(data) }
          let(:data) { {foo: :bar} }

          it "returns failure with data" do
            expect(result_spec.calculate_value).to be_failure.with_data(data)
          end
        end
      end

      context "when result spec for error" do
        let(:result_spec) { described_class.new(status: :error, service_class: service_class) }

        it "returns error" do
          expect(result_spec.calculate_value).to be_error
        end

        it "returns stubbed result" do
          expect(result_spec.calculate_value.stubbed_result?).to eq(true)
        end

        context "when result spec for error with message" do
          let(:result_spec) { described_class.new(status: :error, service_class: service_class).with_message(message) }
          let(:message) { "foo" }

          it "returns error with message" do
            expect(result_spec.calculate_value).to be_error.with_message(message)
          end

          context "when result spec for error with message and code" do
            let(:result_spec) { described_class.new(status: :error, service_class: service_class).with_message(message).and_code(code) }
            let(:code) { :foo }

            it "returns error with message" do
              expect(result_spec.calculate_value).to be_error.with_message(message).and_code(code)
            end
          end
        end

        context "when result spec for error with code" do
          let(:result_spec) { described_class.new(status: :error, service_class: service_class).with_code(code) }
          let(:code) { :foo }

          it "returns error with code" do
            expect(result_spec.calculate_value).to be_error.with_code(code)
          end

          context "when result spec for error with code and message" do
            let(:result_spec) { described_class.new(status: :error, service_class: service_class).with_code(code).and_message(message) }
            let(:message) { "foo" }

            it "returns error with message" do
              expect(result_spec.calculate_value).to be_error.with_code(code).and_message(message)
            end
          end
        end
      end

      context "when result spec for success" do
        let(:result_spec) { described_class.new(status: :success, service_class: service_class) }

        it "returns success" do
          expect(result_spec.calculate_value).to be_success
        end

        it "returns stubbed result" do
          expect(result_spec.calculate_value.stubbed_result?).to eq(true)
        end

        context "when result spec for success with data" do
          let(:result_spec) { described_class.new(status: :success, service_class: service_class).with_data(data) }
          let(:data) { {foo: :bar} }

          it "returns success with data" do
            expect(result_spec.calculate_value).to be_success.with_data(data)
          end
        end
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(result_spec == other).to be_nil
          end
        end

        context "when `other` has different `status`" do
          let(:other) { described_class.new(status: :error, service_class: service_class, chain: chain) }

          it "returns `false`" do
            expect(result_spec == other).to eq(false)
          end
        end

        context "when `other` has different `service_class`" do
          let(:other) { described_class.new(status: status, service_class: Class.new, chain: chain) }

          it "returns `false`" do
            expect(result_spec == other).to eq(false)
          end
        end

        context "when `other` has different `chain`" do
          let(:other) { described_class.new(status: status, service_class: service_class, chain: {args: [:bar], kwargs: {bar: :foo}, block: -> { :bar }}) }

          it "returns `false`" do
            expect(result_spec == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(status: status, service_class: service_class, chain: chain) }

          it "returns `true`" do
            expect(result_spec == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
