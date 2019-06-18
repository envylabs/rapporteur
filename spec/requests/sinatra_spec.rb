# frozen_string_literal: true

ENV["RACK_ENV"] = "test"

begin
  require "sinatra/base"
  require "rack/test"

  RSpec.describe "Sinatra" do
    include Rack::Test::Methods

    class TestApp < Sinatra::Base
      get "/status.json" do
        content_type :json
        body Rapporteur.run.as_json.to_json
      end
    end

    def app
      TestApp
    end

    before do
      Rapporteur.add_check(Rapporteur::Checks::TimeCheck)
    end

    it "responds with an HTTP 200 JSON response" do
      make_request

      expect(last_response).to have_attributes(
        content_type: Mime[:json],
        status:       200
      )
    end

    it "responds with valid JSON" do
      make_request
      expect { JSON.parse(last_response.body) }.not_to(raise_error)
    end

    it "contains the time in ISO8601" do
      allow(Time).to receive(:now).and_return(Time.gm(2013, 8, 23))
      make_request

      expect(last_response).to include_status_message("time", /^2013-08-23T00:00:00(?:.000)?Z$/)
    end

    context "the response payload" do
      it "does not contain errors" do
        make_request
        expect(JSON.parse(last_response.body)).not_to(have_key("errors"))
      end
    end

    private

    def make_request
      get("/status.json")
    end
  end
rescue LoadError
end
