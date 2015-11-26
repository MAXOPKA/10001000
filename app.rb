require 'rack'
require 'sinatra'
require 'slim'
require 'yaml'

require "sinatra/reloader" if development?

class App < Sinatra::Base

  before do
    set_settings
  end

  get '/' do
    @title = 'Главная'
    slim :main
  endt

  get '/about' do
    @title = 'О сайте'
    slim :about
  end

  #use Rack::Auth::Basic, "Protected Area" do |username, password|
  #  username == 'feoo' && password == 'bar'
  #end

  get '/settings' do
    @title = 'Настройки'
    slim :settings
  end

  post '/settings' do
    @settings['app']['target'] = params[:app][:target].to_f
    @settings['app']['current'] = params[:app][:current].to_f
    File.open('config/app.yml', 'w') {|f| f.write @settings.to_yaml }
    redirect '/settings'
  end

  private

  def set_settings
    @settings = YAML.load_file('config/app.yml')
  end

end
