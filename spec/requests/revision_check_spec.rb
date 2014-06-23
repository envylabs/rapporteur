require 'spec_helper'

describe 'A status request with a RevisionCheck', :type => :request do
  before do
    Rapporteur::Revision.stub(:current) { 'revisionidentifier' }
    Rapporteur.add_check(Rapporteur::Checks::RevisionCheck)
  end

  subject { get(status_path) ; response }

  it_behaves_like 'a successful status response'

  context 'the response payload' do
    it 'contains the current application revision' do
      expect(subject).to include_status_message('revision', 'revisionidentifier')
    end
  end
end
