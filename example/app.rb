# encoding: utf-8
require 'www'

class App < Www::Base
  get '/'
  def index(params)
    params
  end

  get '/foo'
  def foo
    haml :title => 'foo', :body => 'bar'
  end

  get '/(\d{4})/(\d{2})/(\d{2})' # ex: /2009/10/10
  def entry(year, month, date)
    [year, month, date]
  end
end
