require 'sinatra'
require 'sinatra/reloader' if development?
require 'omniauth-twitter'

use OmniAuth::Builder do
  provider :twitter, 'klaUMdq8Bx7EV6LdOYVJ58xIC', 'Wh0t5YJcOPKyBunCYzyQwoFtRtpMAyzS1ofl6bFlD4RBMUyvfo'
end

configure do
  enable :sessions
end

helpers do
  def admin?
    session[:admin]
  end
end

get '/public' do
  "<h3>This is the public page - everybody is welcome!</h3>"
end

get '/private' do
  halt(401, 'Not Authorized') unless admin?
  "<h3>This is the privite page - members only</h1>
   <p>You are logged in as <strong>#{session[:username]}</strong></p>"
end

get '/login' do
  redirect to("/auth/twitter")
end

get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  session[:username] = env['omniauth.auth']['info']['name']
  "<h3>Hi #{session[:username]}!</h3>"
end

get '/auth/failure' do
  params[:message]
end

get '/logout' do
  session[:admin] = nil
  session[:username] = nil
  "You are now logged out"
end
