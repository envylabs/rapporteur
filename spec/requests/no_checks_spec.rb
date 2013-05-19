require 'spec_helper'

describe 'A status request with no checks' do
  before { Codeschool::Status::Checker.clear }

  subject { get(status_path) ; response }

  it_behaves_like 'a successful status response'
end
