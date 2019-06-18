# frozen_string_literal: true

RSpec.describe "A check calling #halt!", type: :request do
  let(:parsed_response) { JSON.parse(response.body) }

  before do
    Rapporteur.add_check do |checker| checker.add_message(:one, 1) end
    Rapporteur.add_check do |checker| checker.add_message(:two, 2).halt! end
    Rapporteur.add_check do |checker| checker.add_message(:three, 3) end

    get(rapporteur.status_path(format: "json"))
  end

  it "runs the first check" do
    expect(parsed_response).to include("one")
  end

  it "runs the second check" do
    expect(parsed_response).to include("two")
  end

  it "does not run any checks after #halt! is called" do
    expect(parsed_response).not_to include("three")
  end
end
