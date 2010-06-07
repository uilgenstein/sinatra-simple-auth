require 'rubygems'
require 'sinatra/base'
require File.expand_path('../../lib/sinatra/simple_auth', __FILE__)

class MockApplication < Sinatra::Base
  register Sinatra::SimpleAuth
 
  set :environment, :test
  enable :sessions
 
  set :home, '/secret'
  set :login, 'admin'
  set :password, 'abcxyz'

  def authorize(login, password)
    login == settings.login && password == settings.password
  end
  
  get '/' do
    "Root"
  end
  
  get '/foo' do
  end

  get '/public' do
    if authorized?
      "hello %username%"
    else
      "Please login"
    end
  end

  get '/protected' do
    login_required
    "private area"
  end
end
