class MeetupController < ApplicationController
  def home
  end

  def callback
    puts request.env['omniauth.auth'].to_h
    session['auth'] = request.env['omniauth.auth']

    redirect_to '/events'
  end

  def events
    @events = meetup().self_events
  end

  def event
    @event = meetup().event(urlname, event_id)
  end

  def people_random
    attendes = meetup().attendence(urlname, event_id)
    @person = attendes.shuffle.pop['member']
    # binding.pry
  end

  private
  def meetup
    BaseMeetup.new session['auth']['credentials']['token']
  end

  def urlname
    params.require(:urlname)
  end

  def event_id
    params.require(:event_id)
  end
end
