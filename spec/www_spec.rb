class Foo < Www::Base
  view_dir File.join(File.dirname(__FILE__), 'views')

  before {}
  before :foo_required

  get '/'
  def index
    "index"
  end

  get '/foo'
  def foo(params)
    haml :params => params
  end

  get '/regexp/?(.*)'
  def regexp(arg, params)
    "#{arg} - #{params.inspect}"
  end

  get '/(\d{4})/(\d{2})/(\d{2})'
  def entry(year, month, date)
    [year, month, date]
  end

  def foo_required
  end
end

def app
  Www::App
end

describe "Www" do
  it 'should call before block' do
    foo = Foo.new
    2.times do
      mock.proxy(foo).foo_required
      mock.proxy(foo).instance_eval(&Foo.before_blocks[0])
      foo.index
    end
  end

  it 'should call index as "/"' do
    get('/').body.should == "index"
  end

  it 'should call foo as "/foo" with params' do
    params = {'foo' => 'bar'}
    get('/foo', params).body.chomp.should == params.inspect
  end

  it 'should call regexp as "/regexp/..."' do
    get('/regexp/foo').body.should == "foo - #{{}.inspect}"
  end

  it 'should call regexp as "/regexp/..." with params' do
    params = {'foo' => 'bar'}
    get('/regexp/foo', params).body.should == "foo - #{params.inspect}"
  end

  it 'should call entry as "/2010/10/15"' do
    get('/2010/10/15').body.should == ['2010', '10', '15'].inspect
  end
end
