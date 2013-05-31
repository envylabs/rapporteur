require 'spec_helper'

describe 'A status request with a check that modifies messages' do
  subject { get(status_path) ; response }

  context 'creating a message with a block' do
    before do
      Rapporteur::Checker.clear
      Rapporteur::Checker.add_check { |checker| checker.add_message('git_repo', 'git@github.com:organization/repo.git') }
    end

    context 'with an unerring response' do
      it_behaves_like 'a successful status response'

      it 'responds with the check\'s messages' do
        expect(subject).to include_status_message('git_repo', 'git@github.com:organization/repo.git')
      end
    end

    context 'with an erring response' do
      before do
        Rapporteur::Checker.add_check { |checker| checker.add_error(:base, 'failed') }
      end

      it_behaves_like 'an erred status response'

      it 'does not respond with the check\'s messages' do
        expect(subject).not_to include_status_message('git_repo', 'git@github.com:organization/repo.git')
      end
    end

    context 'with no message-modifying checks' do
      before { Rapporteur::Checker.clear }

      it_behaves_like 'a successful status response'

      it 'does not respond with a messages list' do
        expect(JSON.parse(subject.body)).not_to(have_key('messages'))
      end
    end
  end
end
