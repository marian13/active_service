# frozen_string_literal: true

module ConvenientService
  module Examples
    module Dry
      module Gemfile
        module Services
          class RunShell
            include DryServiceConfig

            option :command
            option :debug, default: -> { false }

            contract do
              schema do
                required(:command).value(:string)
                optional(:debug).value(:bool)
              end
            end

            def result
              Services::PrintShellCommand.result(text: command) if debug

              ##
              # NOTE: When the command exit code is 0, `system' return true, and false otherwise.
              # - https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-system
              # - https://stackoverflow.com/a/37329716/12201472
              #
              if system(command)
                success
              else
                error(message: "#{command} returned non-zero exit code")
              end
            end
          end
        end
      end
    end
  end
end
