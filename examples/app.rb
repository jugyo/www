# encoding: utf-8
require 'www'

class Foo < Www
  before do
    # do something
  end

  route '/' # /
  def index
    "index"
  end

  route '/foo' # /foo
  def foo
    "foo"
  end

  route %r{/regexp/?(.*)} # ex: /regexp/foo
  def regexp(arg)
    arg
  end

  route %r{/(\d{4})/(\d{2})/(\d{2})} # ex: /2009/10/10
  def entry(year, month, date)
    [year, month, date]
  end
end
