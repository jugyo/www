# encoding: utf-8
require 'www'

class Foo < Www::Base
  before do
    # do something
  end

  get '/'
  def index
    "index"
  end

  get '/foo'
  def foo(params)
    haml :title => 'foo'
  end

  get '/regexp/?(.*)' # ex: /regexp/foo
  def regexp(arg, params)
    "#{arg} - #{params.inspect}"
  end

  get '/(\d{4})/(\d{2})/(\d{2})' # ex: /2009/10/10
  def entry(year, month, date)
    [year, month, date]
  end

  def helper
    'bar'
  end
end
