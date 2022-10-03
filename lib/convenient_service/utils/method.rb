# frozen_string_literal: true

require_relative "method/defined"
require_relative "method/find_own"
require_relative "method/find_own_from_class"

module ConvenientService
  module Utils
    module Method
      class << self
        ##
        # ConvenientService::Utils::Method.defined?(:reverse, in: String)
        #
        def defined?(method_name, **kwargs)
          Defined.call(method_name, **kwargs)
        end

        def find_own(method_name, instance, **kwargs)
          FindOwn.call(method_name, instance, **kwargs)
        end

        def find_own_from_class(method_name, klass, **kwargs)
          FindOwnFromClass.call(method_name, klass, **kwargs)
        end
      end
    end
  end
end
