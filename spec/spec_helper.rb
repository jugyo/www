$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'www'
require 'rspec'
require 'rspec/autorun'
require 'rack/test'

include Rack::Test::Methods

RSpec.configure do |config|
  config.mock_with :rr
end
