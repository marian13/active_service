# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(described_class::Concern) }
  end
end
# rubocop:enable RSpec/NestedGroups
