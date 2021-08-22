require 'rails_helper'

RSpec.describe Sale do
  let!(:price) { 1500 }
  let!(:percent) { 30 }
  let!(:result) { Sale.new(price, percent) }
  

  it "return sale" do
    result_price = result.calculate

    expect(result_price).to eq 1050
  end
end