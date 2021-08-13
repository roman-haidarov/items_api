require 'rails_helper'

RSpec.describe ItemsController, type: :request do
  let!(:user) { create :user }

  describe "GET /index" do
    let!(:items) { create_list :item, 3, user: user }

    before { get "/users/#{user.id}/items" }

    it "returns http success" do
      expect(last_response.status).to eq 200
    end

    it "return items collection" do
      expect(response_json).to match parse_json(items)
    end
  end

  describe "GET /show" do
    context "when record exist" do
      let!(:item) { create :item, user: user }

      before { get "/users/#{user.id}/items/#{item.id}" }

      it "return status 200" do
        expect(last_response.status).to eq 200
      end
  
      it "return item data" do
        expect(response_json).to match parse_json(item)
      end
    end
    
    context "when record is not exist" do
      let(:item_id) { "0" }

      before { get "/users/#{user.id}/items/#{item_id}" }

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
      post "/users/#{user.id}/items", item: item_params
    end

    context "when params is valid" do
      let!(:item_params) { { name: "viktor", price: 140 } }
  
      it "return status 201" do
        expect(last_response.status).to eq 201
      end
  
      it "record is created" do
        expect(response_json['name']).to eq "viktor"
      end      
    end
    
    context "when params is invalid" do
      let!(:item_params) { { name: "viktor", price: nil } }
  
      it "return status 400" do
        expect(last_response.status).to eq 400
      end
  
      it "record is created" do
        expect(response_json['message']).to eq "Record not created"
      end      
    end
  end

  describe "PATCH /update" do
    let!(:item) { create :item, user: user }
    let!(:item_params) { { name: "updated_name", price: 160 } }

    context "when record exist" do
      before do
        patch "/users/#{user.id}/items/#{item.id}", item: item_params
      end
  
      context "when params is valid?" do
        it "retern status 200" do
          expect(last_response.status).to eq 200 
        end
    
        it "render correct data of item" do
          expect(response_json['name']).to eq "updated_name"
          expect(response_json['price']).to eq 160
        end
      end
      
      context "when params invalid" do
        let!(:item_second) { create :item, name: "already taken", user: user }
        let!(:item_params) { { name: item_second.name, price: 160, user_id: user.id } }
  
        it "retern status 400" do
          expect(last_response.status).to eq 400
        end
    
        it "render correct data of item" do
          expect(response_json['message']).to eq "Record not updated"
        end
      end
    end

    context "when record is not exist" do
      let(:item_id) { "0" }

      before { patch "/users/#{user.id}/items/#{item_id}", item: item_params }

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
      let!(:item) { create :item, user: user }

      before { delete "/users/#{user.id}/items/#{item.id}" }

      it "return status 204" do
        expect(last_response.status).to eq 204
      end
    end
    
    context "when record is not exist" do
      let(:item_id) { "0" }

      before { delete "/users/#{user.id}/items/#{item_id}" }

      it "return status 404" do
        expect(last_response.status).to eq 404
      end
  
      it "return item data" do
        expect(response_json['message']).to eq "Record not found"
      end
    end
  end
end
