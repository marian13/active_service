# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::PrintShellCommand do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(command: command, skip: skip, out: out) }

      let(:command) { "ls -a" }
      let(:skip) { false }
      let(:out) { Tempfile.new }

      context "when `PrintShellCommand` is NOT successful" do
        context "when skipping" do
          let(:skip) { true }

          it "returns `failure` with `message`" do
            expect(result).to be_failure.with_message("Printing of shell command `#{command}` is skipped").of_service(described_class).without_step
          end
        end
      end

      context "when `PrintShellCommand` is successful" do
        let(:out_content) { out.tap(&:rewind).read }

        it "prints command" do
          result

          expect(out_content).to match(/\$ #{command}/)
        end

        specify do
          expect { result }
            .to delegate_to(Paint, :[])
            .with_arguments("$ #{command}", :blue, :bold)
        end

        it "returns `success`" do
          expect(result).to be_success.without_data.of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
