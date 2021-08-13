require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET /index" do
    let!(:users) { create_list :user, 3 }

    before { get "/users" }

    it "returns http success" do
      expect(last_response.status).to eq 200
    end

    it "return items collection" do
      expect(response_json).to match parse_json(users)
    end
  end

  describe "GET /show" do
    context "when record exist" do
      let!(:user) { create :user }

      before { get "/users/#{user.id}" }

      it "return status 200" do
        expect(last_response.status).to eq 200
      end
  
      it "return item data" do
        expect(response_json).to match parse_json(user)
      end
    end
    
    context "when record is not exist" do
      let(:user_id) { "0" }

      before { get "/users/#{user_id}" }

      it "return status 404" do
        expect(last_response.status).to eq 404
      end
  
      it "return item data" do
        expect(response_json['message']).to eq "Record not found"
      end
    end
  end

  describe "POST /create" do
    before do
      post "/users", user: user_params
    end

    context "when params is valid" do
      let!(:user_params) { { email: "viktor@mail.com", password: "777", name: "Viktor" } }
  
      it "return status 201" do
        expect(last_response.status).to eq 201
      end
  
      it "record is created" do
        expect(response_json['email']).to eq "viktor@mail.com"
      end      
    end
    
    context "when params is invalid" do
      let!(:user_params) { { email: "viktor" } }
  
      it "return status 400" do
        expect(last_response.status).to eq 400
      end
  
      it "record is created" do
        expect(response_json['message']).to eq "User not created"
      end      
    end
  end

  describe "PATCH /update" do
    let!(:user) { create :user }
    let!(:user_params) { { name: "updated_name" } }

    context "when record exist" do
      before do
        patch "/users/#{user.id}", user: user_params
      end
  
      context "when params is valid?" do
        it "retern status 200" do
          expect(last_response.status).to eq 200 
        end
    
        it "render correct data of item" do
          expect(response_json['name']).to eq "updated_name"
        end
      end
      
      context "when params invalid" do
        let!(:user_second) { create :user, email: "test@test.com" }
        let!(:user_params) { { email: user_second.email } }
  
        it "retern status 400" do
          expect(last_response.status).to eq 400
        end
    
        it "render correct data of user" do
          expect(response_json['message']).to eq "User not updated"
        end
      end
    end

    context "when record is not exist" do
      let(:user_id) { "0" }

      before { patch "/users/#{user_id}", user: user_params }

      it "return status 404" do
        expect(last_response.status).to eq 404
      end
  
      it "return error message" do
        expect(response_json['message']).to eq "Record not found"
      end
    end
  end

  describe "DELETE /destroy" do

    context "when record exist" do
      let!(:user) { create :user }

      before { delete "/users/#{user.id}" }

      it "return status 204" do
        expect(last_response.status).to eq 204
      end
    end
    
    context "when record is not exist" do
      let(:user_id) { "0" }

      before { delete "/users/#{user_id}" }

      it "return status 404" do
        expect(last_response.status).to eq 404
      end
  
      it "return user data" do
        expect(response_json['message']).to eq "Record not found"
      end
    end
  end
end
