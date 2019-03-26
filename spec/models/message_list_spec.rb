# frozen_string_literal: true

RSpec.describe Rapporteur::MessageList, type: :model do
  let(:list) { Rapporteur::MessageList.new(:errors) }

  before { I18n.backend.reload! }

  context '#add' do
    it 'returns the MessageList instance.' do
      expect(list.add(:test, 'message')).to equal(list)
    end

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

    it 'translates and adds recognized I18n keys with named parameters in the #full_messages' do
      add_translation(:errors, :test, :i18n_message, 'translated %{language}')
      list.add(:test, :i18n_message, language: 'French')
      expect(list.full_messages).to include('test translated French')
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

  context '#to_hash' do
    it 'flattens key/value pairs with only one value' do
      list.add(:test, 'message')
      expect(list.to_hash).to eq(test: 'message')
    end

    it 'retains multiple values for a single key' do
      list.add(:test, 'message1')
      list.add(:test, 'message2')
      result = list.to_hash
      expect(result).to have_key(:test)
      expect(result[:test]).to include('message1')
      expect(result[:test]).to include('message2')
    end

    it 'returns a new, unique, but equivalent Hash with each call' do
      list.add(:test, 'message')
      return1 = list.to_hash
      return2 = list.to_hash
      expect(return1).not_to equal(return2)
      expect(return1).to eq(return2)
    end
  end

  private

  def add_translation(type, key, message, string)
    I18n.backend.store_translations('en', rapporteur: { type.to_sym => { key.to_sym => { message.to_sym => string } } })
  end
end
