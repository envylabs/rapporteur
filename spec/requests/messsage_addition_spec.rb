require 'spec_helper'
require 'JSON'
describe 'A status request with an RepoCheck' do
  subject { get(status_path) ; response }

  context 'creating a message with a lambda' do
    let(:repo) { {git_repo: "git@github.com:organization/repo.git"} }

    before do
      Rapporteur::Checker.clear
      Rapporteur::Checker.add_check(Proc.new { repo })
      
    end
    
    it 'works' do
     body = JSON.parse(subject.body)
     body["messages"].include?({"git_repo" => "git@github.com:organization/repo.git"}).should == true
    end
  end

end
