# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'A status request with a TimeCheck', type: :request do
  before do
    Rapporteur.add_check(Rapporteur::Checks::TimeCheck)

    allow(Time).to receive(:now).and_return(Time.gm(2013, 8, 23))

    get(rapporteur.status_path(format: 'json'))
  end

  it_behaves_like 'a successful status response'

  context 'the response payload' do
    it 'contains the time in ISO8601' do
      expect(response).to include_status_message('time', /^2013-08-23T00:00:00(?:.000)?Z$/)
    end
  end
end
