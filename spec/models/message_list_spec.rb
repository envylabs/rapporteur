require 'spec_helper'

describe Rapporteur::MessageList do
  let(:list) { Rapporteur::MessageList.new(:errors) }

  before { I18n.backend.reload! }

  context '#add' do
    it 'adds a String message to the #full_messages' do
      list.add(:test, 'message')
      expect(list.full_messages).to include('test message')
    end

    it 'adds unrecognized Symbols as Strings to the #full_messages' do
      list.add(:test, :message)
      expect(list.full_messages).to include('test message')
    end

    it 'adds multiple messages to an attribute' do
      list.add(:test, 'message 1')
      list.add(:test, 'message 2')
      expect(list.full_messages).to include('test message 1')
      expect(list.full_messages).to include('test message 2')
    end

    it 'translates and adds recognized I18n keys in the #full_messages' do
      add_translation(:errors, :test, :i18n_message, 'translated')
      list.add(:test, :i18n_message)
      expect(list.full_messages).to include('test translated')
    end

    it 'translates based on the initialized list type' do
      add_translation(:string, :test, :i18n_message, 'strings')
      add_translation(:messages, :test, :i18n_message, 'messages')
      add_translation(:errors, :test, :i18n_message, 'errors')
      message_list = Rapporteur::MessageList.new(:messages)
      error_list = Rapporteur::MessageList.new(:errors)
      message_list.add(:test, :i18n_message)
      error_list.add(:test, :i18n_message)
      expect(message_list.full_messages).to include('test messages')
      expect(message_list.full_messages).not_to include('test errors')
      expect(error_list.full_messages).to include('test errors')
      expect(error_list.full_messages).not_to include('test messages')
    end
  end


  private


  def add_translation(type, key, message, string)
    I18n.backend.store_translations('en', {rapporteur: {type.to_sym => {key.to_sym => {message.to_sym => string}}}})
  end
end
