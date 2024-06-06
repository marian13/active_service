# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      ##
      # @api private
      #
      # @note `HasMermaidFlowchart` is experimental. It is NOT decided yet whether its support will be continued. For example, it does NOT work with `or_step`.
      #
      module HasMermaidFlowchart
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart]
            #
            def mermaid_flowchart
              Entities::Flowchart.new(service: self)
            end
          end
        end
      end
    end
  end
end
