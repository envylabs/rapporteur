# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A status request with no checks', type: :request do
  before do
    get(rapporteur.status_path(format: 'json'))
  end

  it_behaves_like 'a successful status response'
end
