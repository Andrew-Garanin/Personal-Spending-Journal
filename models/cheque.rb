# One cheque
class Cheque
  attr_reader :place, :date, :number, :product, :category, :price, :count

  def initialize(place, date, number, product, category, price, count)
    @place = place
    @date = date
    @number = number
    @product = product
    @category = category
    @price = price
    @count = count
  end
end
