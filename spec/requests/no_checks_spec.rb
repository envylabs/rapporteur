require 'spec_helper'

describe 'A status request with no checks', :type => :request do
  before do
    get_json(rapporteur.root_path)
  end

  it_behaves_like 'a successful status response'
end
