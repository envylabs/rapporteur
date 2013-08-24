require 'forwardable'
require 'set'

module Rapporteur
  # A container of keys and one or more messages per key. This acts similarly
  # to an ActiveModel::Errors collection from Ruby on Rails.
  #
  class MessageList
    extend Forwardable


    def_delegator :@messages, :clear
    def_delegator :@messages, :empty?


    # Public: Initialize a new MessageList instance.
    #
    # list_type - A Symbol representing the type of this list. This Symbol is
    #             used to determine the structure of the I18n key used when
    #             translating the given message Symbols.
    #             Allowed values: :messages or :errors.
    #
    # Returns a MessageList instance.
    #
    def initialize(list_type)
      @list_type = list_type
      @messages = Hash.new { |hash, key| hash[key] = Set.new }
    end


    # Public: Adds a new message to the list for the given attribute.
    #
    # attribute - A Symbol describing the category, attribute, or name to which
    #             the message pertains.
    # message - A Symbol, String, or Proc which contains the message for the
    #           attribute.
    #
    #           If a String is given, it is directly used for the message.
    #
    #           If a Symbol is given, it is used to lookup the full message
    #           from I18n, under the "rapporteur.<list_type>.<message Symbol>"
    #           key. For instance, if this is a :messages list, and the
    #           attribute is :time, then I18n would be queried for
    #           "rapporteur.messages.time".
    #
    #           If a Proc is given, it is `.call`'d with no parameters. The
    #           return value from the Proc is directly used for the message.
    #
    # Examples
    #
    #     list.add(:time, '2013-08-23T12:34:00Z')
    #     list.add(:time, :too_late)
    #     list.add(:time, lambda { Time.now.iso8601 })
    #
    # Returns the MessageList instance.
    #
    def add(attribute, message)
      @messages[attribute.to_sym].add(normalize_message(attribute, message))
      self
    end

    # Public: Generates an Array containing the combination of all of the added
    # attributes and their messages.
    #
    # Examples
    #
    #     list.add(:time, 'is now')
    #     list.add(:time, 'is valuable')
    #     list.add(:day, 'is today')
    #     list.full_messages
    #     # => ["time is now", "time is valuable", "day is today"]
    #
    # Returns an Array containing Strings of messages.
    #
    def full_messages
      @messages.map { |attribute, attribute_messages|
        attribute_messages.collect { |message| "#{attribute} #{message}" }
      }.flatten
    end

    # Public: Returns the added attributes and their messages as a Hash, keyed
    # by the attribute, with an Array containing all of the added messages.
    #
    # Examples
    #
    #     list.add(:time, 'is now')
    #     list.add(:time, 'is valuable')
    #     list.add(:day, 'is today')
    #     list.full_messages
    #     # => {:time => ["is now", "is valuable"], :day => ["is today"]}
    #
    # Returns a Hash instance.
    #
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
