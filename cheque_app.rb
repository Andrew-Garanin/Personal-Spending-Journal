# frozen_string_literal: true

require 'forme'
require 'roda'

require_relative 'models'

# The application class
class ChequeApplication < Roda
  opts[:root] = __dir__
  plugin :environments
  plugin :forme
  plugin :hash_routes
  plugin :path
  plugin :render
  plugin :status_handler
  plugin :view_options

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  require_relative 'routes/cheques'
  # require_relative 'routes/people'

  #   opts[:store] = Store.new
  # opts[:cheques] = opts[:store].bill_list

  (opts[:cheques] = ChequeList.new).read_data(File.expand_path('db/cheques.csv', __dir__))
  opts[:uniq_dates] = opts[:cheques].uniq_dates
  opts[:categories] = opts[:cheques].uniq_categories
  pp opts[:categories]
  status_handler(404) do
    view('/not_found')
  end

  route do |r|
    r.public if opts[:serve_static]
    r.hash_branches

    r.root do
      r.redirect cheques_path
    end
  end
end
