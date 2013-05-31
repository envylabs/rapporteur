require 'spec_helper'

describe 'A status request with a RevisionCheck' do
  before do
    Rapporteur::Checker.add_check(Rapporteur::Checks::RevisionCheck)
  end

  subject { get(status_path) ; response }

  it_behaves_like 'a successful status response'

  context 'the response payload' do
    subject { get(status_path) ; JSON.parse(response.body) }

    it 'contains the current application revision' do
      expect(subject.fetch('revision')).to(match(/^[a-f0-9]{40}$/))
    end
  end
end
