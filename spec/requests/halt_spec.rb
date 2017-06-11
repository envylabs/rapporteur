# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A check calling #halt!', type: :request do
  let(:parsed_response) { JSON.parse(response.body) }

  before do
    Rapporteur.add_check { |checker| checker.add_message(:one, 1) }
    Rapporteur.add_check { |checker| checker.add_message(:two, 2).halt! }
    Rapporteur.add_check { |checker| checker.add_message(:three, 3) }

    get(rapporteur.status_path(format: 'json'))
  end

  it 'runs the first check' do
    expect(parsed_response).to include('one')
  end

  it 'runs the second check' do
    expect(parsed_response).to include('two')
  end

  it 'does not run any checks after #halt! is called' do
    expect(parsed_response).not_to include('three')
  end
end
