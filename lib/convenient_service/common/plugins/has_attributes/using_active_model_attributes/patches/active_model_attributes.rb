# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasAttributes
        module UsingActiveModelAttributes
          ##
          # TODO: Remove this patch when Rails updates `def initialize(*)' to  `def initialize(*args, **kwargs, &block)'.
          # https://github.com/rails/rails/blob/3872bc0e54d32e8bf3a6299b0bfe173d94b072fc/activemodel/lib/active_model/attributes.rb#L78
          #
          module Patches
            ##
            # NOTE: Naming/ConstantName is disabled to allow dynamic module creation.
            #
            # rubocop:disable Naming/ConstantName
            ActiveModelAttributes =
              ##
              # Copy of `ActiveModel::Attributes'.
              # https://api.rubyonrails.org/classes/ActiveModel/Attributes/ClassMethods.html
              #
              ::ActiveModel::Attributes.dup.tap do |mod|
                mod.module_eval do
                  ##
                  # NOTE: Overrides `initialize' since current Rails implementation can not accept kwargs.
                  #
                  # TODO: Open a PR to Rails.
                  #
                  def initialize(*args, **kwargs, &block)
                    ##
                    # IMPORTANT: Should be kept in sync with:
                    # https://github.com/rails/rails/blob/3872bc0e54d32e8bf3a6299b0bfe173d94b072fc/activemodel/lib/active_model/attributes.rb#L78
                    #
                    @attributes = self.class._default_attributes.deep_dup
                    super
                  end
                end
              end
            # rubocop:enable Naming/ConstantName
          end
        end
      end
    end
  end
end
