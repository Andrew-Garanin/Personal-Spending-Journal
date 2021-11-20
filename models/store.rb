# frozen_string_literal: true

require 'csv'
require_relative 'cheque_list'
require_relative 'cheque'

# Storage for all of our data
class Store
  attr_reader :cheque_list

  DATA_FILE = File.expand_path('../db/cheques.csv', dir)

  def initialize
    @bill_list = BillList.new
    read_data
  end

  def read_data
    return unless File.exist?(DATA_STORE)

    yaml_data = File.read(DATA_STORE)
    raw_data = Psych.load(yaml_data, symbolize_names: true)
    raw_data[:bill_list].each do |raw_bill|
      @bill_list.add_real_bill(Bill.new(**raw_bill))
    end
  end
end
