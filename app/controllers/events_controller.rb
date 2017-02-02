class EventsController < ApplicationController
  def index
    @events = meetup.self_events
  end

  def show
    @event = meetup.event(urlname, event_id)
  end

  def random_attendee
    attendes = meetup.attendence(urlname, event_id)
    person = attendes.shuffle.pop[:member]
    @image = person[:photo][:thumb] if person && person[:photo]
    @image ||= ['brown-egg.jpg','white-egg.jpg'].shuffle.pop
    @name = person[:name]
  end

  private
  def meetup
    BaseMeetup.new session
  end

  def urlname
    params.require(:urlname)
  end

  def event_id
    params.require(:event_id)
  end
end
