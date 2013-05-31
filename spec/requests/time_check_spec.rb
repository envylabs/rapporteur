require 'spec_helper'

describe 'A status request with a TimeCheck' do
  before do
    Rapporteur::Checker.add_check(Rapporteur::Checks::TimeCheck)
  end

  subject { get(status_path) ; response }

  it_behaves_like 'a successful status response'

  context 'the response payload' do
    subject { get(status_path) ; JSON.parse(response.body) }

    it 'contains the current time in ISO8601' do
      time = Time.now
      Time.stub(:now).and_return(time)
      expect(subject.fetch('time')).to(match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/))
      expect(subject.fetch('time')).to(eq(time.utc.iso8601))
    end
  end
end

