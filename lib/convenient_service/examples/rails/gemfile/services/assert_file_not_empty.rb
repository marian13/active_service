# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      class Gemfile
        module Services
          class AssertFileNotEmpty
            include RailsService::Config

            attribute :path, :string

            validates :path, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?

            def result
              return failure("File with path `#{path}` is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
