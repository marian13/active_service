# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Standard::Gemfile::Services::AssertNpmPackageAvailable.result(name: "lodash")
#
module ConvenientService
  module Examples
    module Standard
      class Gemfile
        module Services
          class AssertNpmPackageAvailable
            include ConvenientService::Standard::Config

            attr_reader :name

            step :validate_name

            step Services::AssertNodeAvailable

            ##
            # NOTE: `> /dev/null 2>&1` is used to hide output.
            # https://unix.stackexchange.com/a/119650/394253
            #
            # NOTE: For `npm list` and its options docs, see
            # https://docs.npmjs.com/cli/v7/commands/npm-ls
            #
            step Services::RunShellCommand, in: {command: -> { "npm list #{name} --depth=0 > /dev/null 2>&1" }}

            def initialize(name:)
              @name = name
            end

            private

            def validate_name
              return error("Name is `nil`") if name.nil?
              return error("Name is empty") if name.empty?

              success
            end
          end
        end
      end
    end
  end
end
