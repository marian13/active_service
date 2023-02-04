# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Dry::Gemfile::Services::AssertNodeAvailable.result
#
module ConvenientService
  module Examples
    module Dry
      module Gemfile
        module Services
          class AssertNodeAvailable
            include DryService::Config

            ##
            # NOTE: `> /dev/null 2>&1` is used to hide output.
            # https://unix.stackexchange.com/a/119650/394253
            #
            step Services::RunShell, in: {command: -> { "which node > /dev/null 2>&1" }}
          end
        end
      end
    end
  end
end