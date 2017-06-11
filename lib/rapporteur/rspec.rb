require 'rapporteur'

shared_examples_for 'a successful status response' do
  let(:parsed_body) { JSON.parse(response.body) }

  it 'responds with HTTP 200' do
    expect(response.response_code).to(eq(200))
  end

  context 'the response headers' do
    it 'contains a Content-Type JSON header' do
      expect(response.content_type).to(eq(Mime[:json]))
    end

    it 'does not contain an ETag header' do
      expect(response.headers).not_to have_key('ETag')
    end

    it 'contains a Cache-Control header which disables client caching' do
      expect(response.headers.fetch('Cache-Control')).to eq('no-cache')
    end
  end

  context 'the response payload' do
    it 'does not contain errors' do
      expect(parsed_body).not_to(have_key('errors'))
    end
  end
end

shared_examples_for 'an erred status response' do
  let(:parsed_body) { JSON.parse(response.body) }

  it 'responds with HTTP 500' do
    expect(response.response_code).to(eq(500))
  end

  context 'the response headers' do
    it 'contains a Content-Type JSON header' do
      expect(response.content_type).to(eq(Mime[:json]))
    end

    it 'does not contain an ETag header' do
      expect(response.headers).not_to have_key('ETag')
    end

    it 'contains a Cache-Control header which disables client caching' do
      expect(response.headers.fetch('Cache-Control')).to eq('no-cache')
    end
  end

  context 'the response payload' do
    it 'contains errors' do
      expect(parsed_body).to(have_key('errors'))
      expect(parsed_body.fetch('errors')).not_to(be_empty)
    end
  end
end

RSpec::Matchers.define :include_status_error_message do |attribute, message|
  match do |response|
    @body = JSON.parse(response.body)
    @body.fetch('errors', {}).fetch(attribute.to_s).match(message)
  end

  failure_message_for_should do |actual|
    "expected #{@body.inspect} to include a #{attribute}:#{message.inspect} error message"
  end

  failure_message_for_should_not do |actual|
    "expected #{@body.inspect} to not include a #{attribute}:#{message.inspect} error message"
  end
end

RSpec::Matchers.define :include_status_message do |name, message|
  match do |response|
    @body = JSON.parse(response.body)
    @body.has_key?(name) && @body.fetch(name).match(message)
  end

  failure_message_for_should do |actual|
    "expected #{@body.inspect} to include a #{name.inspect}: #{message.inspect} message"
  end

  failure_message_for_should_not do |actual|
    "expected #{@body.inspect} to not include a #{name.inspect}: #{message.inspect} message"
  end
end
