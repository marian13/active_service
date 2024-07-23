# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Arguments, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:arguments) { described_class.new(*args, **kwargs, &block) }

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { arguments }

    it { is_expected.to have_attr_reader(:args) }
    it { is_expected.to have_attr_reader(:kwargs) }
    it { is_expected.to have_attr_reader(:block) }
  end

  example_group "class methods" do
    describe "#new" do
      context "when args are NOT passed" do
        let(:arguments) { described_class.new(**kwargs, &block) }

        it "defaults to empty array" do
          expect(arguments.args).to eq([])
        end
      end

      context "when kwargs are NOT passed" do
        let(:arguments) { described_class.new(*args, &block) }

        it "defaults to empty hash" do
          expect(arguments.kwargs).to eq({})
        end
      end

      context "when block are NOT passed" do
        let(:arguments) { described_class.new(*args, **kwargs) }

        it "defaults to `nil`" do
          expect(arguments.block).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#null_arguments?" do
      it "returns `false`" do
        expect(arguments.null_arguments?).to eq(false)
      end
    end

    describe "#any?" do
      context "when arguments have at least one arg" do
        let(:arguments) { described_class.new(*args) }

        it "returns `true`" do
          expect(arguments.any?).to eq(true)
        end
      end

      context "when arguments have at least one kwarg" do
        let(:arguments) { described_class.new(**kwargs) }

        it "returns `true`" do
          expect(arguments.any?).to eq(true)
        end
      end

      context "when arguments have at block" do
        let(:arguments) { described_class.new(&block) }

        it "returns `true`" do
          expect(arguments.any?).to eq(true)
        end
      end

      context "when arguments do NOT have args, kwargs and block" do
        let(:arguments) { described_class.new }

        it "returns `false`" do
          expect(arguments.any?).to eq(false)
        end
      end
    end

    describe "#none?" do
      context "when arguments have at least one arg" do
        let(:arguments) { described_class.new(*args) }

        it "returns `false`" do
          expect(arguments.none?).to eq(false)
        end
      end

      context "when arguments have at least one kwarg" do
        let(:arguments) { described_class.new(**kwargs) }

        it "returns `false`" do
          expect(arguments.none?).to eq(false)
        end
      end

      context "when arguments have at block" do
        let(:arguments) { described_class.new(&block) }

        it "returns `false`" do
          expect(arguments.none?).to eq(false)
        end
      end

      context "when arguments do NOT have args, kwargs and block" do
        let(:arguments) { described_class.new }

        it "returns `true`" do
          expect(arguments.none?).to eq(true)
        end
      end
    end

    describe "#[]" do
      context "when `key` is NOT valid" do
        let(:key) { "abc" }

        let(:exception_message) do
          <<~TEXT
            `#[]` accepts only `Integer` and `String` keys.

            Key `#{key.inspect}` has `#{key.class}` class.
          TEXT
        end

        it "raises `ConvenientService::Support::Arguments::Exceptions::InvalidKeyType`" do
          expect { arguments[key] }
            .to raise_error(ConvenientService::Support::Arguments::Exceptions::InvalidKeyType)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Support::Arguments::Exceptions::InvalidKeyType) { arguments[key] } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when `key` is valid" do
        context "when `key` is integer" do
          let(:key) { 0 }

          specify do
            expect { arguments[key] }
              .to delegate_to(arguments.args, :[])
              .with_arguments(key)
              .and_return_its_value
          end
        end

        context "when `key` is symbol" do
          let(:key) { :foo }

          specify do
            expect { arguments[key] }
              .to delegate_to(arguments.kwargs, :[])
              .with_arguments(key)
              .and_return_its_value
          end
        end
      end
    end

    describe "#==" do
      subject(:arguments) { described_class.new(*args, **kwargs, &block) }

      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(arguments == other).to be_nil
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(:bar, **kwargs, &block) }

        it "returns `false`" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(*args, {bar: :baz}, &block) }

        it "returns `false`" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(*args, **kwargs, &other_block) }
        let(:other_block) { proc { :bar } }

        it "returns `false`" do
          expect(arguments == other).to eq(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(*args, **kwargs, &block) }

        it "returns `true`" do
          expect(arguments == other).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
