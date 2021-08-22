require 'rails_helper'

RSpec.describe YearsUser do
  let!(:user) { create :user, born_years: 2000 }
  let!(:service_object) { YearsUser.new(user) }

  it "return years" do
    calculated_years = service_object.calculate

    expect(calculated_years).to eq DateTime.now.year - 2000
  end
end