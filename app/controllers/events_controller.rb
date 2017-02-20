class EventsController < ApplicationController
  def index
    @events = randsome.available_events
  end

  def show
    @event = meetup.event(urlname, event_id)
  end

  def random_attendee
    @person = randsome.random_attendee(urlname , event_id)
  end

  private
  def meetup
    BaseMeetup.new session
  end

  def randsome
    Randsome.new session
  end

  def urlname
    params.require(:urlname)
  end

  def event_id
    params.require(:event_id)
  end
end
