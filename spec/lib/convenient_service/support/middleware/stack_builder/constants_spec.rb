# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Constants, type: :standard do
  example_group "constants" do
    describe "::Backends::RUBY_MIDDLEWARE" do
      it "returns `:ruby_middleware`" do
        expect(described_class::Backends::RUBY_MIDDLEWARE).to eq(:ruby_middleware)
      end
    end

    describe "::Backends::RACK" do
      it "returns `:rack`" do
        expect(described_class::Backends::RACK).to eq(:rack)
      end
    end

    describe "::Backends::ALL" do
      it "returns `[:ruby_middleware, :rack]`" do
        expect(described_class::Backends::ALL).to eq([described_class::Backends::RUBY_MIDDLEWARE, described_class::Backends::RACK])
      end
    end

    describe "::Backends::DEFAULT" do
      it "returns `ConvenientService::Support::Middleware::StackBuilder::Constants::Backends::RUBY_MIDDLEWARE`" do
        expect(described_class::Backends::DEFAULT).to eq(described_class::Backends::RUBY_MIDDLEWARE)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
