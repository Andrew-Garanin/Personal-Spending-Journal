# frozen_string_literal: true

# Routes for the bills of this application
class ChequeApplication
  opts[:str] = ''
  opts[:collect] = []
  path :cheques, '/cheques'

  hash_branch('cheques') do |r|
    append_view_subdir('cheques')
    set_layout_options(template: '../views/layout')
    r.is do
      view('cheques')
    end

    r.on 'months' do
      @dates = opts[:uniq_dates]

      r.is do
        view('dates')
      end
      r.get String do |month|
        @month = month
        @cheques = []
        opts[:cheques].each_cheque do |cheque|
          @cheques << cheque if cheque.date[0..6].eql?(@month)
        end
        view('month')
      end
    end

    r.on 'categories' do
      @categories = opts[:categories]

      r.is do
        view('categories')
      end
      r.get String do |category|
        @category = URI.decode_www_form_component(category).to_s
        @cheques = []
        @hash = {}
        @hash_products = {}
        opts[:cheques].each_cheque do |cheque|
          next unless cheque.category.eql?(@category)

          @cheques << cheque if cheque.category.eql?(@category)
        end

        @buys = {}
        @cheques.each do |cheque|
          first = @buys[cheque.number]
          if first.nil?
            first = Cheque.new(cheque.place, cheque.date, cheque.number, cheque.product, cheque.category, cheque.price, 0)
          end

          if first.number.eql?(cheque.number) && first.product.eql?(cheque.product)
            @buys[cheque.number] = Cheque.new(first.place, first.date, first.number, first.product, first.category, first.price, first.count.to_i + cheque.count.to_i)
          else
            @buys[cheque.number] = cheque
          end
        end
        @cheques_small = []
        @buys.each do |_key, value|
          @cheques_small << value
        end

        @max = 0
        @max_number = 0
        @cheques_small.each do |cheque|
          if cheque.price.to_i * cheque.count.to_i > @max
            @max = cheque.price.to_i * cheque.count.to_i
            @max_number = cheque.number
          end
        end

        @min = @max
        @min_number = 0
        @cheques_small.each do |cheque|
          if cheque.price.to_i * cheque.count.to_i < @min
            @min = cheque.price.to_i * cheque.count.to_i
            @min_number = cheque.number
          end
        end

        @min_cheque = @buys[@min_number]
        @max_cheque = @buys[@max_number]

        @max_date = Date.parse('2001-01-01')
        @cheques.each do |cheque|
          date = Date.parse(cheque.date)
          @max_date = date if date > @max_date
        end
        @max_date = @max_date.to_s
        @cheques_dates = @cheques_small.filter { |cheque| cheque.date[0..6].eql?(@max_date[0..6]) }

        view('category')
      end
    end
  end
end
