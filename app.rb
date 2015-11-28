require 'rack'
require 'sinatra'
require 'slim'
require 'yaml'

require "sinatra/reloader" if development?

class App < Sinatra::Base
  private

  before do
    set_settings
  end

  def set_settings
    @settings = YAML.load_file('config/app.yml')
  end

  def save_settings(target, current)
    @settings['app']['target'], @settings['app']['current'] = target, current
    File.open('config/app.yml', 'w') {|f| f.write @settings.to_yaml }
  end

  def self.get_secrets
    set = YAML.load_file('config/secrets.yml')['secrets']
  end
end


class Public < App

  get '/' do
    @title = 'Главная'
    slim :main
  end

  get '/about' do
    @title = 'О сайте'
    slim :about
  end
end

class Protected < App

  use Rack::Auth::Basic, 'Authorize' do |username, password|
    username == get_secrets['login'] && password == get_secrets['password']
  end

  get '/' do
    @title = 'Настройки'
    slim :settings
  end

  post '/' do
    save_settings params[:app][:target].to_f, params[:app][:current].to_f
    redirect '/settings'
  end
end
