class Randsome
  def initialize(session)
    @session = session
  end

  def random_attendee(urlname , event_id)
    attendees = meetup.attendence(urlname , event_id)
    attendees.sample.member
  end

  def available_events
    meetup.self_events.select! do |event|
      hosted_by_user?( event[:event_hosts] )
    end
  end

  private
  def meetup
    BaseMeetup.new @session
  end

  def hosted_by_user? (event_hosts)
    event_hosts.any? do |host|
      host[:id] == @session[:auth]["info"]["id"]
    end
  end
end
