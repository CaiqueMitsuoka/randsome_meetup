class MeetupController < ApplicationController
  def home
  end

  def callback
    session[:auth] = request.env['omniauth.auth'].deep_symbolize_keys
    session[:token] = session[:auth][:credentials][:token]
    session[:refresh_token] = session[:auth][:credentials][:refresh_token]
    redirect_to '/events'
  end
end
