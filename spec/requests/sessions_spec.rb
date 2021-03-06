require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe "POST /create" do
    let!(:user) { create :user, email: "antony@mail.ru" }

    before do
      post "/sessions", login_data: login_data
    end

    context "when user exist" do
      let(:login_data) { { email: "antony@mail.ru", password: "1234" } }

      it "return status created" do
        expect(last_response.status).to eq 201
      end

      it "when password valid" do
        decoded_token = JWT.decode response_json['token'], nil, false

        expect(decoded_token.first["email"]).to eq "antony@mail.ru"
      end
    end
    
    context "when password is wrong" do
      let(:login_data) { { email: "antony@mail.ru", password: "4321" } }

      it "return status created" do
        expect(last_response.status).to eq 400
      end

      it "when password valid" do
        expect(response_json["message"]).to eq "email or password is wrong"   
      end
    end
    
  end
end
