require 'sinatra_app'
require 'test/unit'
require 'rack/test'
begin; require 'turn'; rescue LoadError; end

class SinatraSimpleAuthTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    MockApplication
  end
    
  def test_it_should_login_and_redirect
    login!
    assert_redirect app.home
  end
  
  def test_it_should_fail_login_and_redirect
    post '/login', { :login => 'foo', :password => 'some fake data' }, env
    assert_redirect '/login'
  end
  
  def test_it_should_login_and_redirect_back
    get '/protected', {}, env
    assert_redirect '/login'
    login!
    assert_redirect '/protected'
  end
  
  def test_it_should_logout
    login!
    get '/logout', {}, env
    assert_redirect '/'
    get '/protected', {}, env
    assert_redirect '/login'
  end
  
  def test_authorized_helper_should_work
    get '/public', {}, env
    assert last_response.body.include?("Please login")
    login!
    get '/public', {}, env
    assert last_response.body.include?("%username%")
  end
  
  private
  
  def login!
    post '/login', { :login => app.login, :password => app.password }, env
  end
  
  def assert_redirect(path)
    assert last_response.redirect?
    assert_equal last_response.headers['Location'], env['SCRIPT_NAME'] + path
  end
  
  def env
    { 'SCRIPT_NAME' => '/admin' }
  end
  
end