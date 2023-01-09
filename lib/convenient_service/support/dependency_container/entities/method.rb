# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Entities
        class Method
          ##
          # @!attribute [r] full_name
          #   @return [String, Symbol]
          #
          attr_reader :full_name

          ##
          # @!attribute [r] scope
          #   @return [:instance, :class]
          #
          attr_reader :scope

          ##
          # @!attribute [r] body
          #   @return [Proc]
          #
          attr_reader :body

          ##
          # @param full_name [String, Symbol]
          # @param scope [:instance, :class]
          # @param body [Proc]
          # @return [void]
          #
          def initialize(full_name:, scope:, body:)
            @full_name = full_name
            @scope = scope
            @body = body
          end

          ##
          # @return [String]
          #
          def name
            @name ||= full_name_parts.last
          end

          ##
          # @return [Array<String>]
          #
          def namespaces
            @namespaces ||= full_name_parts.slice(0..-2).map { |part| Entities::Namespace.new(name: part) }
          end

          ##
          # @param mod [Module]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          def define_in_module!(mod)
            namespaces_and_method.reduce(mod) do |namespace, method|
              namespace.define_method(method.name) { |*args, **kwargs, &block| method.body.call(*args, **kwargs, &block) }

              method
            end

            method
          end

          ##
          # @return [Array<ConvenientService::Support::DependencyContainer::Entities::Namespace, ConvenientService::Support::DependencyContainer::Entities::Method>]
          #
          def namespaces_and_method
            @namespaces_and_method ||= namespaces + [method]
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if full_name != other.full_name
            return false if scope != other.scope
            return false if body != other.body

            true
          end

          private

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          def method
            self
          end

          ##
          # @return [Array<String>]
          #
          def full_name_parts
            @full_name_parts ||= full_name.to_s.split(".")
          end
        end
      end
    end
  end
end
