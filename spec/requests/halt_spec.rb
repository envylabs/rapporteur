require 'spec_helper'

describe 'A check calling #halt!', :type => :request do
  before do
    Rapporteur.add_check { |checker| checker.add_message(:one, 1) }
    Rapporteur.add_check { |checker| checker.add_message(:two, 2).halt! }
    Rapporteur.add_check { |checker| checker.add_message(:three, 3) }
  end

  subject { get(status_path) ; JSON.parse(response.body) }

  it 'runs the first check' do
    expect(subject).to include('one')
  end

  it 'runs the second check' do
    expect(subject).to include('two')
  end

  it 'does not run any checks after #halt! is called' do
    expect(subject).not_to include('three')
  end
end
