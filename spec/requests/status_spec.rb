require 'spec_helper'

describe 'The status response' do
  subject { get(status_path) ; response }

  it 'responds with HTTP 200' do
    expect(subject.response_code).to eq(200)
  end

  it 'responds with a JSON content header' do
    expect(subject.content_type).to eq(Mime::JSON)
  end

  it 'responds with valid JSON' do
    expect { JSON.parse(subject.body) }.not_to raise_error
  end

  context 'the response payload' do
    subject { get(status_path) ; JSON.parse(response.body) }

    it 'contains the current application revision' do
      expect(subject.fetch('revision')).to match(/^[a-f0-9]{40}$/)
    end

    it 'contains the current time in ISO8601' do
      time = Time.now
      Time.stub(:now).and_return(time)
      expect(subject.fetch('time')).to match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/)
      expect(subject.fetch('time')).to eq(time.utc.iso8601)
    end
  end

  context 'with a failed ActiveRecord connection' do
    before { ActiveRecord::Base.connection.stub(:execute).and_raise(ActiveRecord::ConnectionNotEstablished) }
    subject { get(status_path) ; response }

    it 'responds with an HTTP 500 Server Error' do
      expect(subject.response_code).to eq(500)
    end

    it 'responds with a JSON content header' do
      expect(subject.content_type).to eq(Mime::JSON)
    end

    it 'contains errors' do
      expect(JSON.parse(subject.body)).to have_key('errors')
    end

    context 'the errors payload' do
      subject { get(status_path) ; JSON.parse(response.body).fetch('errors') }

      it 'contains a base message regarding the database' do
        expect(subject.fetch('base')).to include(I18n.t('activemodel.errors.models.codeschool/status/checker.attributes.base.database_unavailable'))
      end
    end
  end
end
