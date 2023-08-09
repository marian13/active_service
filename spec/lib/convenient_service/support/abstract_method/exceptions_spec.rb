# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::AbstractMethod::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::AbstractMethodNotOverridden).to be_descendant_of(ConvenientService::Exception) }
end
