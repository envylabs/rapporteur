require 'spec_helper'

describe 'A status request with a TimeCheck', :type => :request do
  before do
    Rapporteur.add_check(Rapporteur::Checks::TimeCheck)
  end

  subject { get(status_path) ; response }

  it_behaves_like 'a successful status response'

  context 'the response payload' do
    it 'contains the time in ISO8601' do
      allow(Time).to receive(:now).and_return(Time.gm(2013,8,23))
      expect(subject).to include_status_message('time', Time.gm(2013,8,23).iso8601)
    end
  end
end

