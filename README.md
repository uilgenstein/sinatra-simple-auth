##Sinatra SimpleAuth Extension

Extends Sinatra with extension methods and routes for dealing with a simple authorization method. 
Both Sinatra application styles are supported: "Classic" and "Classy" (modular) style.

##Installation

    gem build sinatra-simple-auth.gemspec
    gem install sinatra-simple-auth-0.1.1.gem

##Usage for "Classic" style applications

    require 'rubygems'
    require 'sinatra'
    require 'sinatra/simple_auth'

    enable :sessions
    set    :home, '/secure/' #where user should be redirected after successful authorization

    def authorize(login, password)
      # return value will be saved in session[:user_id]
      login if login == 'bob' && password == 'secret
    end

    get '/login/?' do
      erb :login #page with logon form
    end

    get '/secure/?' do
      login_required #protected route, requires auth
      erb :secure
    end

    get '/' do
      if authorized? #helper method
        "Hello, your user id is: #{session[:user_id]}"
      else
        "Not authorized"
      end
    end

##Usage for "Classy" style applications

In your config.ru you can mount your proteceted app under a url prefix (e.g. /admin):

    require 'rubygems'
    require 'sinatra/base'
    require 'admin_application
    require 'public_application

    map '/admin' do
      run AdminApplication
    end
    
    map '/' do
      run PublicApplication
    end
    

Your protected application could then look something like this:

    require 'sinatra/simple_auth'

    class AdminApplication < Sinatra::Base
      register Sinatra::SimpleAuth

      enable :sessions
      set    :home, '/' # relative to url prefix from config.ru. 
                        # this is where user should be redirected after successful authorization

      def authorize(login, password)
        # return value will be saved in session[:user_id]
        login if login == 'bob' && password == 'secret
      end

      before do
        login_required unless request.path_info =~ /^\/login\/?$/
      end

      get '/login/?' do
        erb :login #page with logon form
      end

      get '/' do
        if authorized? #helper method
          "Hello, your user id is: #{session[:user_id]}"
        else
          "Not authorized"
        end
      end
    end