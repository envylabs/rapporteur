require "spec_helper"

ENV["RACK_ENV"] = "test"

begin
  require "rack/test"

  describe "Rack" do
    include Rack::Test::Methods


    def app
      Rapporteur::App.new
    end

    before do
      Rapporteur.add_check(Rapporteur::Checks::TimeCheck)
    end


    subject { get("/") ; last_response }

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
      subject { get("/") ; JSON.parse(last_response.body) }

      it 'does not contain errors' do
        expect(subject).not_to(have_key('errors'))
      end
    end

    context 'with an error' do
      before do
        Rapporteur.add_check(Rapporteur::Checks::ActiveRecordCheck)

        allow(ActiveRecord::Base.connection)
          .to receive(:execute)
          .and_raise(ActiveRecord::ConnectionNotEstablished)
      end

      it 'responds with HTTP 500' do
        expect(subject.status).to(eq(500))
      end

      it 'responds with a JSON content header' do
        expect(subject.content_type).to(eq(Mime::JSON))
      end

      it 'responds with valid JSON' do
        expect { JSON.parse(subject.body) }.not_to(raise_error)
      end

      it 'contains an error message' do
        expect(subject).to include_status_error_message(:database, I18n.t('rapporteur.errors.database.unavailable', :raise => true))
      end
    end
  end
rescue LoadError
end
