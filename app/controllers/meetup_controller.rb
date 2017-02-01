class MeetupController < ApplicationController
  def home
  end

  def callback
    session['auth'] = request.env['omniauth.auth']
    redirect_to '/events'
  end
end
