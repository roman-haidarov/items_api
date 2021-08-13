require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user) { create :user }
  let(:item) { build :item, user: user }

  it "model must be valid" do
    expect(item.valid?).to eq true 
  end

  context "when model is invalid?" do
    let(:item) { build :item, user: user, name: nil, price: nil }

    it "return false" do
      expect(item.valid?).to eq false 
    end
  end

  context "when name already exist" do
    let!(:item) { create :item, user: user, name: "ball" }
    let(:second_item) { build :item, user: user, name: "ball" }

    it "return false" do
      expect(second_item.valid?).to eq false 
    end
  end
end
