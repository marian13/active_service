# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::Cowsay do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature) }
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".print" do
      let(:text) { "foo" }
      let(:out) { Tempfile.new }

      specify do
        expect { described_class.print(text, out: out) }
          .to delegate_to(described_class::Services::Print, :result)
          .with_arguments(text: text, out: out)
          .and_return_its_value
      end

      context "when `text` is NOT passed" do
        it "defaults to `\"Hello World!\"`" do
          expect { described_class.print(out: out) }
            .to delegate_to(described_class::Services::Print, :result)
            .with_arguments(text: "Hello World!", out: out)
            .and_return_its_value
        end
      end

      ##
      # FIX: `stub_service` does NOT work in combination with `delegate_to`.
      #
      # context "when `out` is NOT passed" do
      #   include ConvenientService::RSpec::Helpers::StubService
      #
      #   it "defaults to `stdout`" do
      #     stub_service(described_class::Services::Print).to return_success
      #
      #     expect { described_class.print(text) }
      #       .to delegate_to(described_class::Services::Print, :result)
      #       .with_arguments(text: text, out: $stdout)
      #   end
      # end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
