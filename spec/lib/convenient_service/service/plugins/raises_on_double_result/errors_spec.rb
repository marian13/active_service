# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::RaisesOnDoubleResult::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::DoubleResult).to be_descendant_of(ConvenientService::Error) }
end