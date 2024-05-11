# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Reassignment, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:factory) { described_class.new(other: reassignment) }
  let(:reassignment) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment.new(:foo) }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Base) }
  end

  example_group "instance methods" do
    describe "#create_key" do
      specify do
        expect { factory.create_key }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key, :new)
          .with_arguments(factory.other.to_sym)
          .and_return_its_value
      end
    end

    describe "#create_name" do
      specify do
        expect { factory.create_name }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name, :new)
          .with_arguments(factory.other.to_sym)
          .and_return_its_value
      end
    end

    describe "#create_caller" do
      specify do
        expect { factory.create_caller }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Reassignment, :new)
          .with_arguments(factory.other)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
