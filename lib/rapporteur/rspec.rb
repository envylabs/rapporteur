require 'rapporteur'

shared_examples_for 'a successful status response' do
  it 'responds with HTTP 200' do
    expect(subject.response_code).to(eq(200))
  end

  it 'responds with a JSON content header' do
    expect(subject.content_type).to(eq(Mime::JSON))
  end

  it 'responds with valid JSON' do
    expect { JSON.parse(subject.body) }.not_to(raise_error)
  end

  context 'the response payload' do
    subject { get(status_path) ; JSON.parse(response.body) }

    it 'does not contain errors' do
      expect(subject).not_to(have_key('errors'))
    end
  end
end

shared_examples_for 'an erred status response' do
  it 'responds with HTTP 500' do
    expect(subject.response_code).to(eq(500))
  end

  it 'responds with a JSON content header' do
    expect(subject.content_type).to(eq(Mime::JSON))
  end

  it 'responds with valid JSON' do
    expect { JSON.parse(subject.body) }.not_to(raise_error)
  end

  it 'contains errors' do
    expect(JSON.parse(subject.body)).to(have_key('errors'))
    expect(JSON.parse(subject.body).fetch('errors')).not_to(be_empty)
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
