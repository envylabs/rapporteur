require "spec_helper"

ENV["RACK_ENV"] = "test"

begin
  require "sinatra/base"
  require "rack/test"

  describe "Sinatra" do
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


    subject { get("/status.json") ; last_response }

    it 'responds with HTTP 200' do
      expect(subject.status).to(eq(200))
    end

    it 'responds with a JSON content header' do
      expect(subject.content_type).to(eq(Mime::JSON))
    end

    it 'responds with valid JSON' do
      expect { JSON.parse(subject.body) }.not_to(raise_error)
    end

    it 'contains the time in ISO8601' do
      allow(Time).to receive(:now).and_return(Time.gm(2013,8,23))
      expect(subject).to include_status_message('time', /^2013-08-23T00:00:00(?:.000)?Z$/)
    end

    context 'the response payload' do
      subject { get("/status.json") ; JSON.parse(last_response.body) }

      it 'does not contain errors' do
        expect(subject).not_to(have_key('errors'))
      end

    end
  end
rescue LoadError
end
