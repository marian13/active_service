# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Error
          module Commands
            class AssertEitherArgsOrKwargsArePassed < Support::Command
              attr_reader :args, :kwargs

              def initialize(args:, kwargs:)
                @args = args
                @kwargs = kwargs
              end

              def call
                raise Exceptions::BothArgsAndKwargsArePassed.new if args.any? && kwargs.any?
              end
            end
          end
        end
      end
    end
  end
end
