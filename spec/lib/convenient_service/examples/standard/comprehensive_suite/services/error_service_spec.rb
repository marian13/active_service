# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::ComprehensiveSuite::Services::ErrorService, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when `ErrorService` is NOT successful" do
        context "when `index` is NOT passed" do
          subject(:result) { described_class.result }

          let(:default_index) { -1 }

          it "returns `error` with `default index`" do
            expect(result).to be_error.with_data(index: default_index).of_service(described_class).without_step
          end
        end
      end

      context "when `index` is passed" do
        subject(:result) { described_class.result(index: index) }

        let(:index) { 0 }

        it "returns `error` with that passed `index`" do
          expect(result).to be_error.with_data(index: index).of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
