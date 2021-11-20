require 'forwardable'
require 'csv'

# The list of books to manage
class ChequeList
  extend Forwardable
  def_delegator :@cheques, :each, :each_cheque

  def initialize
    @cheques = []
    @uniq_dates = []
    @uniq_categories = []
  end

  def read_data(filename)
    CSV.foreach(filename, headers: true) do |row|
      @cheques << (Cheque.new(String(row['Место']), String(row['Дата']), String(row['Номер']),
                              String(row['Продукт']), String(row['Категория']), String(row['Цена']), String(row['Количество'])))
    end
    @cheques
  end

  def uniq_dates
    @cheques.each do |cheque|
      @uniq_dates << cheque.date[0..6]
    end
    @uniq_dates.uniq
  end

  def uniq_categories
    @cheques.each do |cheque|
      @uniq_categories << cheque.category
    end
    @uniq_categories.uniq
  end

  def max_sum
    @max = 0
    @max_number = 0
    @cheques.each do |cheque|
      if cheque.price.to_i * cheque.count.to_i > @max
        @max = cheque.price.to_i * cheque.count.to_i
        @max_number = cheque.number
      end
    end
    @max_number
  end
end
