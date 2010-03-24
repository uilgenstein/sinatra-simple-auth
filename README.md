##Sinatra SimpleAuth Extension

Extends Sinatra with a extension methods and routes for dealing with a simple, single-password authorization

##Installation

    sudo gem install sinatra-simple-auth -s http://gemcutter.org/

##Usage

    require 'rubygems'
    require 'sinatra'
    require 'sinatra/simple_auth'

    enable :sessions
    set :password, 'my_cool_password' #define single password
    set :home, '/secure/' #where user should be redirected after successful authorization

    get '/a/?' do
      erb :auth #page with logon form
    end

    get '/secure/' do
      protected! #protected route, requires auth
      erb :secure
    end

    get '/' do
      if authorized? #helper method
        "Hello, %username%"
      else
        "Not authorized"
      end
    end