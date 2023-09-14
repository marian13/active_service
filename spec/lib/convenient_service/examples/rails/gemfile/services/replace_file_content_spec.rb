# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::ReplaceFileContent do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {path: path, content: content} }

  let(:file) { Tempfile.new }

  let(:path) { file.path }

  let(:content) do
    <<~RUBY
      gem "bootsnap", ">= 1.4.4", require: false

      group :development do
        gem "listen", "~> 3.3"
      end

      group :development, :test do
        gem "rspec-rails"
      end
    RUBY
  end

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
  end

  describe "#result" do
    subject(:result) { service.result }

    context "when replacing of file content is NOT successful" do
      if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?
        context "when path is NOT present" do
          let(:path) { nil }

          it "returns error with data" do
            expect(result).to be_error.with_data(path: "can't be blank").of_service(described_class).without_step
          end
        end

        context "when content is `nil`" do
          let(:content) { nil }

          it "returns error with data" do
            expect(result).to be_error.with_data(content: "can't be nil").of_service(described_class).without_step
          end
        end
      end

      context "when assertion that file exist is NOT successful" do
        let(:path) { "not_exisiting_file" }

        it "returns intermediate step result" do
          expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Rails::Gemfile::Services::AssertFileExists)
        end
      end
    end

    context "when replacing of file content is successful" do
      it "returns success with contated header and body" do
        expect(result).to be_success.without_data.of_service(described_class).of_step(:result)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
