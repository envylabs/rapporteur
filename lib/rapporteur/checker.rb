require 'singleton'
require 'set'

module Rapporteur
  class Checker
    include Singleton
    include ActiveModel::Validations
    include ActiveModel::SerializerSupport


    def self.add_check(object)
      raise ArgumentError, "A check must respond to #call." unless object.respond_to?(:call)
      instance.checks << object
      self
    end

    def self.clear
      instance.checks.clear
      self
    end

    def self.run
      instance.errors.clear
      instance.run
    end


    def add_error(message)
      errors.add(:base, message)
    end

    def checks
      @checks ||= Set.new
    end

    def revision
      Revision.current
    end

    def run
      checks.each do |object|
        object.call(self)
      end
      self
    end

    def time
      Time.now
    end
  end
end
