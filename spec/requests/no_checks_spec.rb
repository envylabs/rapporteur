require 'spec_helper'

describe 'A status request with no checks', :type => :request do
  subject { get(status_path) ; response }

  it_behaves_like 'a successful status response'
end
