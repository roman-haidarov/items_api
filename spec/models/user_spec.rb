require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  it "model must be valid" do
    expect(user.valid?).to eq true 
  end

  context "when model is invalid?" do
    let(:user) { build :user, email: "ford" }

    it "return false" do
      expect(user.valid?).to eq false 
    end
  end

  context "when email already exist" do
    let!(:user) { create :user, email: "rod@mail.ru" }
    let(:second_user) { build :user, email: "rod@mail.ru" }

    it "return false" do
      expect(second_user.valid?).to eq false 
    end
  end
end
