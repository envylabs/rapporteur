# frozen_string_literal: true

RSpec.describe "A status request with a check that modifies messages", type: :request do
  context "creating a message with a block" do
    context "with an unerring response" do
      before do
        Rapporteur.add_check do |checker| checker.add_message("git_repo", "git@github.com:organization/repo.git") end
        get(rapporteur.status_path(format: "json"))
      end

      it_behaves_like "a successful status response"

      it "responds with the check's messages" do
        expect(response).to include_status_message("git_repo", "git@github.com:organization/repo.git")
      end
    end

    context "with an erring response" do
      before do
        Rapporteur.add_check do |checker| checker.add_error(:base, "failed") end
        get(rapporteur.status_path(format: "json"))
      end

      it_behaves_like "an erred status response"

      it "does not respond with the check's messages" do
        expect(response).not_to include_status_message("git_repo", "git@github.com:organization/repo.git")
      end
    end

    context "with no message-modifying checks" do
      before do
        get(rapporteur.status_path(format: "json"))
      end

      it_behaves_like "a successful status response"

      it "does not respond with a messages list" do
        expect(JSON.parse(response.body)).not_to(have_key("messages"))
      end
    end
  end
end
