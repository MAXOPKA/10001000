
ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

require 'rspec'
require 'rack/test'
require 'faker'
require 'factory_girl'


describe '10001000 app' do
  include Rack::Test::Methods

  def app() Sinatra::Application end

  describe do 'app responses'
    it 'render root' do
      get '/'
      expect(last_response.body).to include 'Тысяча тысяч'
    end

    it 'render about' do
      get '/about'
      expect(last_response.body).to include 'Обо мне'
    end
  end
end
