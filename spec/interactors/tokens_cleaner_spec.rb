require 'rails_helper'

RSpec.describe TokensCleaner do
  let!(:cleaner) { TokensCleaner }
  let!(:user) { create :user }

  before do
    3.times {TokensCreator.new(user).call}
    user.tokens.last(2).each { |token| token.update(expired_in: Time.current - 1.hour) }
  end

  it "user must be have only not expired tokens after tokens cleaner" do
    expect(user.tokens.count).to eq 3

    cleaner.call

    expect(user.tokens.count).to eq 1
  end
end