require 'rapporteur'

shared_examples_for 'a successful status response' do
  let(:parsed_body) { JSON.parse(response.body) }

  it 'responds with HTTP 200' do
    expect(response.response_code).to(eq(200))
  end

  it 'responds with a JSON content header' do
    expect(response.content_type).to(eq(Mime[:json]))
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

  it 'responds with a JSON content header' do
    expect(response.content_type).to(eq(Mime[:json]))
  end

  it 'contains errors' do
    expect(parsed_body).to(have_key('errors'))
    expect(parsed_body.fetch('errors')).not_to(be_empty)
  end
end

RSpec::Matchers.define :include_status_error_message do |attribute, message|
  match do |response|
    @body = JSON.parse(response.body)
    @body.fetch('errors', {}).fetch(attribute.to_s).match(message)
  end

  failure_message_when_negated do |actual|
    "expected #{@body.inspect} to not include a #{attribute}:#{message.inspect} error message"
  end
end

RSpec::Matchers.define :include_status_message do |name, message|
  match do |response|
    @body = JSON.parse(response.body)

    @body.has_key?(name) && @body.fetch(name).match(message)
  end

  failure_message do |actual|
    "expected #{@body.inspect} to include a #{name.inspect}: #{message.inspect} message"
  end

  failure_message_when_negated do |actual|
    "expected #{@body.inspect} to not include a #{name.inspect}: #{message.inspect} message"
  end
end
