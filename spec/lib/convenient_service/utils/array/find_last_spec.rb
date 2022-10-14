# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array::FindLast do
  describe ".call" do
    subject(:result) { described_class.call(array) { |item| item[0] == "b" } }

    context "when array does NOT contain item to find" do
      let(:array) { ["foo"] }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "when array contains one item to find" do
      let(:array) { ["foo", "bar"] }

      it "returns that item" do
        expect(result).to eq("bar")
      end
    end

    context "when array contains multiple items to find" do
      let(:array) { ["foo", "bar", "baz"] }

      it "returns last from those items" do
        expect(result).to eq("baz")
      end
    end
  end
end
