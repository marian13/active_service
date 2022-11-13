# frozen_string_literal: true

require_relative "gemfile/services"

##
# Usage example:
#
# result = ConvenientService::Examples::Standard::Gemfile.format(path: "Gemfile")
# result = ConvenientService::Examples::Standard::Gemfile.format(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Standard
      module Gemfile
        class << self
          def format
            Services::Format[path: path]
          end
        end
      end
    end
  end
end