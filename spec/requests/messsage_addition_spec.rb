require 'spec_helper'

describe 'A status request with a check that modifies messages' do
  subject { get(status_path) ; response }

  context 'creating a message with a lambda' do
    before do
      Rapporteur::Checker.clear
      Rapporteur::Checker.add_check(Proc.new { |checker| checker.add_message('git_repo', 'git@github.com:organization/repo.git') })
    end

    context 'with an unerring response' do
      it 'responds with the check\'s messages' do
        expect(subject).to include_status_message('git_repo', 'git@github.com:organization/repo.git')
      end
    end
  end
end
