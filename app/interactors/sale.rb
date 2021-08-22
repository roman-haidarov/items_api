class Sale
  def initialize(price, percent)
    @price = price
    @percent = percent
  end

  def calculate
    (@price/100) * (100 - @percent)
  end
end