# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatBacktrace do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(backtrace: exception.backtrace, max_size: max_size) }

      let(:exception) do
        service_class.result
      rescue => error
        error
      end

      let(:max_size) { 5 }

      context "when exception has backtrace with short backtrace" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              raise StandardError, "exception message", caller.take(5)
            end
          end
        end

        let(:formatted_backtrace) do
          <<~MESSAGE.chomp
            #{exception.backtrace.map { |line| "# #{line}" }.join("\n")}
          MESSAGE
        end

        it "returns formatted full backtrace" do
          expect(command_result).to eq(formatted_backtrace)
        end
      end

      context "when exception has backtrace with long backtrace" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              raise StandardError, "exception message", caller + ["# /line.rb:1:in `foo'"] * 10
            end
          end
        end

        let(:formatted_backtrace) do
          <<~MESSAGE.chomp
            #{exception.backtrace.take(5).map { |line| "# #{line}" }.join("\n")}
            # ...
          MESSAGE
        end

        it "returns formatted trimmed backtrace" do
          expect(command_result).to eq(formatted_backtrace)
        end
      end

      context "when `max_size` is NOT passed" do
        subject(:command_result) { described_class.call(backtrace: exception.backtrace) }

        let(:service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              raise StandardError, "exception message", caller + ["# /line.rb:1:in `foo'"] * 10
            end
          end
        end

        let(:formatted_backtrace) do
          <<~MESSAGE.chomp
            #{exception.backtrace.take(10).map { |line| "# #{line}" }.join("\n")}
            # ...
          MESSAGE
        end

        it "defaults to `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::DEFAULT_MAX_BACKTRACE_SIZE`" do
          expect(command_result).to eq(formatted_backtrace)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
