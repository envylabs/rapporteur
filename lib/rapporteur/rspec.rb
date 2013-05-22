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

    it 'contains the current application revision' do
      expect(subject.fetch('revision')).to(match(/^[a-f0-9]{40}$/))
    end

    it 'contains the current time in ISO8601' do
      time = Time.now
      Time.stub(:now).and_return(time)
      expect(subject.fetch('time')).to(match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/))
      expect(subject.fetch('time')).to(eq(time.utc.iso8601))
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

RSpec::Matchers.define :include_status_error_message do |message|
  match do |response|
    @body = JSON.parse(response.body)
    @body.fetch('errors', {}).fetch('base').include?(message)
  end

  failure_message_for_should do |actual|
    "expected #{@body.inspect} to include a #{message.inspect} error message"
  end

  failure_message_for_should_not do |actual|
    "expected #{@body.inspect} to not include a #{message.inspect} error message"
  end
end

RSpec::Matchers.define :include_status_message do |name, message|
  match do |response|
    @body = JSON.parse(response.body)
    messages = @body.fetch('messages', {})
    messages.has_key?(name) && messages.fetch(name) == message
  end

  failure_message_for_should do |actual|
    "expected #{@body.inspect} to include a #{name.inspect}: #{message.inspect} message"
  end

  failure_message_for_should_not do |actual|
    "expected #{@body.inspect} to not include a #{name.inspect}: #{message.inspect} message"
  end
end
