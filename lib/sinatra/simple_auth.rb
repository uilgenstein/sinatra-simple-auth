require 'sinatra/base'

module Sinatra
  module SimpleAuth
    module Helpers

      def authorize(login, password)
        nil
      end

      def authorized?
        session[:user_id]
      end
      alias :logged_in? :authorized?
                  
      def login_required
        unless authorized?
          store_location
          redirect full_app_path('/login')
        end
      end

      def store_location
        session[:return_to] = request.path_info if request.get?
      end
      
      private

      def redirect_back_or_default(default)
        if session[:return_to] && session[:return_to] !=~ Regexp.new("^/login/?$")
          back = session[:return_to].clone
          session[:return_to] = nil
          redirect full_app_path(back)
        end
        redirect full_app_path(default)
      end

      def full_app_path(path)
        request.script_name + path
      end

    end

    def self.registered(app)
      app.helpers SimpleAuth::Helpers

      app.set :home, '/'

      app.post '/login/?' do
        if user_id = authorize(params[:login], params[:password])
          session[:user_id] = user_id
          redirect_back_or_default(settings.home)
        end
        redirect full_app_path('/login')
      end

      app.get '/logout/?' do
        session.clear
        redirect full_app_path('/')
      end

    end
  end

  register SimpleAuth
end
   