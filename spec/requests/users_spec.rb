require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET /index" do
    let!(:current_user) { create :user }
    let!(:role) { create :role, permission: "admin" }
    let!(:users) { create_list :user, 3 }
    let!(:token) { TokensCreator.new(current_user).call }

    context "when user is admin" do
      let!(:user_role) { create :user_role, user: current_user, role: role }

      before do
        get "/users", {},
        "HTTP_AUTHORIZATION" => "Bearer #{token}"
      end

      it "return status ok" do
        expect(last_response.status).to eq 200
      end

      it "return user collection" do
        users_ids = users.pluck(:id)
        users_ids << current_user.id
        expect(response_json.pluck('id')).to match users_ids.sort
      end
    end

    context "when user is not admin" do
      before do
        get "/users", {},
        "HTTP_AUTHORIZATION" => "Bearer #{token}"
      end

      it "returns http success" do
        expect(last_response.status).to eq 403
      end
  
      it "return items collection" do
        expect(response_json["message"]).to eq "Access Denied"
      end
    end

    context "when user not authenticated" do
      let!(:token) { "undefined" }

      before do
        get "/users", {},
        "HTTP_AUTHORIZATION" => "Bearer #{token}"
      end

      it "returns http success" do
        expect(last_response.status).to eq 403
      end
  
      it "return items collection" do
        expect(response_json["message"]).to eq "Access Denied"
      end
    end
  end

  describe "GET /show" do
    let!(:current_user) { create :user }    
    let!(:user) { create :user }

    context "when user is admin" do
      let!(:role) { create :role, permission: "admin" }
      let!(:user_role) { create :user_role, role: role, user: current_user }
      let!(:token) { TokensCreator.new(current_user).call }

      before do
        get "/users/#{search_id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when record exist" do
        let!(:search_id) { user.id }
  
        it "return status 200" do
          expect(last_response.status).to eq 200
        end
    
        it "return item data" do
          expect(response_json).to match parse_json(user)
        end
      end
      
      context "when record is not exist" do
        let(:search_id) { "0" }
  
        it "return status 404" do
          expect(last_response.status).to eq 404
        end
    
        it "return item data" do
          expect(response_json['message']).to eq "Record not found"
        end
      end
    end

    context "when user is not admin and tries to see himself" do
      let!(:role) { create :role }
      let!(:user_role) { create :user_role, role: role, user: user }
      let!(:token) { TokensCreator.new(user).call }

      before do
        get "/users/#{search_id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when record exist" do
        let!(:search_id) { user.id }
  
        it "return status 200" do
          expect(last_response.status).to eq 200
        end
    
        it "return item data" do
          expect(response_json).to match parse_json(user)
        end
      end
      
      context "when record is not exist" do
        let(:search_id) { "0" }
  
        it "return status 404" do
          expect(last_response.status).to eq 404
        end
    
        it "return item data" do
          expect(response_json['message']).to eq "Record not found"
        end
      end
    end

    context "when user is not admin and tries to see another users" do
      let!(:role) { create :role }
      let!(:user_role) { create :user_role, role: role, user: current_user }
      let!(:token) { TokensCreator.new(current_user).call }

      before do
        get "/users/#{search_id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when record exist" do
        let!(:search_id) { user.id }
  
        it "return status 403" do
          expect(last_response.status).to eq 403
        end
    
        it "return item data" do
          expect(response_json['message']).to eq "Access Denied"
        end
      end
      
      context "when record is not exist" do
        let(:search_id) { "0" }
  
        it "return status 404" do
          expect(last_response.status).to eq 404
        end
    
        it "return item data" do
          expect(response_json['message']).to eq "Record not found"
        end
      end
    end

    context "when user not authenticated" do
      let!(:token) { "undefined" }

      before do
        get "/users/#{search_id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when record exist" do
        let!(:search_id) { user.id }
  
        it "return status 403" do
          expect(last_response.status).to eq 403
        end
    
        it "return item data" do
          expect(response_json['message']).to eq "Access Denied"
        end
      end
    end
  end

  describe "POST /create" do
    before do
      post "/users", user: user_params
    end

    context "when params is valid" do
      let!(:user_params) { { email: "viktor@mail.com", password: "777", name: "Viktor", born_years: '1991' } }
  
      it "return status 201" do
        expect(last_response.status).to eq 201
      end
  
      it "record is created" do
        expect(response_json['email']).to eq "viktor@mail.com"
      end
      
      it "return encrypted password" do
        expect(response_json['password']).to eq Base64.encode64("777")
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
    let!(:current_user) { create :user }
    let!(:user) { create :user }
    let!(:role) { create :role, permission: "admin" }
    let!(:token) { TokensCreator.new(current_user).call }
    
    context "when user is admin" do
      let!(:user_role) { create :user_role, role: role, user: current_user }

      before do
        patch "/users/#{user.id}",
        { user: user_params },
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end
        
      context "when user successfully updated" do
        let!(:user_params) { { email: "viktor@mail.com", password: "777", name: "Viktor", born_years: '1991' } }

        it "retern status 200" do
          expect(last_response.status).to eq 200 
        end
      
        it "render correct data" do
          expect(response_json['email']).to eq "viktor@mail.com"
        end
          
        it "return encrypted password" do
          expect(response_json['password']).to eq Base64.encode64("777")
        end
      end
        
      context "when user not update" do
        let!(:user_params) { { email: "viktor@mail" } }
    
        it "retern status 400" do
          expect(last_response.status).to eq 400
        end
      
        it "render correct data of user" do
          expect(response_json['message']).to eq "User not updated"
        end
      end
      
  
      context "when record is not exist" do
        let!(:user_params) { { email: "viktor@mail.com", password: "777", name: "Viktor", born_years: '1991' } }
        let(:user_id) { "0" }
    
        before do
          patch "/users/#{user_id}",
          { user: user_params },
          { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
        end
    
        it "return status 404" do
          expect(last_response.status).to eq 404
        end
      
        it "return error message" do
          expect(response_json['message']).to eq "Record not found"
        end
      end
    end

    context "when user is not admin and tries update himself" do
      let!(:role) { create :role }
      let!(:user_role) { create :user_role, role: role, user: user }
      let!(:user_params) { { email: "viktor@mail.com", password: "777", name: "Viktor", born_years: '1991' } }
      let!(:token) { TokensCreator.new(user).call }
      let!(:user_id) { user.id }

      before do
        patch "/users/#{user_id}",
        { user: user_params },
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end
        
      context "when user successfully updated" do
        it "retern status 200" do
          expect(last_response.status).to eq 200 
        end
      
        it "render correct data" do
          expect(response_json['email']).to eq "viktor@mail.com"
        end
          
        it "return encrypted password" do
          expect(response_json['password']).to eq Base64.encode64("777")
        end
      end
        
      context "when user not update" do
        let!(:user_params) { { email: "viktor@mail" } }
    
        it "retern status 400" do
          expect(last_response.status).to eq 400
        end
      
        it "render correct data of user" do
          expect(response_json['message']).to eq "User not updated"
        end
      end
      
      context "when record is not exist" do
        let(:user_id) { "0" }
    
        it "return status 404" do
          expect(last_response.status).to eq 404
        end
      
        it "return error message" do
          expect(response_json['message']).to eq "Record not found"
        end
      end
    end

    context "when user is not admin and tries to update anather user" do
      let!(:role) { create :role }
      let!(:user_role) { create :user_role, role: role, user: current_user }
      let!(:user_params) { { email: "viktor@mail.com", password: "777", name: "Viktor", born_years: '1991' } }
      let!(:token) { TokensCreator.new(current_user).call }
      let!(:user_id) { user.id }

      before do
        patch "/users/#{user_id}",
        { user: user_params },
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end
        
      context "when user successfully updated" do
        it "retern status unauthorize" do
          expect(last_response.status).to eq 403 
        end
      
        it "render correct data" do
          expect(response_json['message']).to eq "Access Denied"
        end
      end
    end
  
    context "when user not authenticated" do
      let!(:token) { "undefined" }
      let!(:user_id) { user.id }

      before do
        patch "/users/#{user_id}",
        { user: user_params },
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end
        
      context "when user successfully updated" do
        let!(:user_params) { { email: "viktor@mail.com", password: "777", name: "Viktor", born_years: '1991' } }
        it "retern status unauthorize" do
          expect(last_response.status).to eq 403 
        end
      
        it "render correct data" do
          expect(response_json['message']).to eq "Access Denied"
        end
      end
    end 
  end

  describe "DELETE /destroy" do

  let!(:user) { create :user }
  let!(:current_user) { create :user }

    context "when user is admin" do
      let!(:role) { create :role, permission: "admin" }
      let!(:user_role) { create :user_role, role: role, user: current_user }
      let!(:token) { TokensCreator.new(current_user).call }

      before do
        delete "/users/#{user.id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when user successfully deleted" do
        it "return status 204" do
          expect(last_response.status).to eq 204
        end
      end
    end

    context "when user not admin and tries to delete himself" do
      let!(:role) { create :role }
      let!(:user_role) { create :user_role, role: role, user: user }
      let!(:token) { TokensCreator.new(user).call }

      before do
        delete "/users/#{user.id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when user successfully deleted" do
        it "return status 204" do
          expect(last_response.status).to eq 403
        end
      end
    end

    context "when user not admin and tries to delete another user" do
      let!(:role) { create :role }
      let!(:user_role) { create :user_role, role: role, user: current_user }
      let!(:token) { TokensCreator.new(current_user).call }

      before do
        delete "/users/#{user.id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when user successfully deleted" do
        it "return status 204" do
          expect(last_response.status).to eq 403
        end
      end
    end

    context "when user not authenticated" do
      let!(:token) { "undefined" }

      before do
        delete "/users/#{user.id}", {},
        { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      context "when user successfully deleted" do
        it "return status 204" do
          expect(last_response.status).to eq 403
        end
      end
    end
  end
end