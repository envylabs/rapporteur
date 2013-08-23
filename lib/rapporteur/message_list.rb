require 'forwardable'
require 'set'

module Rapporteur
  class MessageList
    extend Forwardable


    def_delegator :@messages, :clear
    def_delegator :@messages, :empty?


    def initialize(list_type)
      @list_type = list_type
      @messages = Hash.new { |hash, key| hash[key] = Set.new }
    end


    def add(attribute, message)
      @messages[attribute.to_sym].add(normalize_message(attribute, message))
    end

    def full_messages
      @messages.map { |attribute, attribute_messages|
        attribute_messages.collect { |message| "#{attribute} #{message}" }
      }.flatten
    end

    def to_hash
      @messages.dup
    end


    private


    def generate_message(key, type)
      I18n.translate(type, {
        :default => [type, type.to_s],
        :scope => [:rapporteur, @list_type, key]
      })
    end

    def normalize_message(attribute, message)
      case message
      when Symbol
        generate_message(attribute, message)
      when Proc
        message.call
      else
        message
      end
    end
  end
end
