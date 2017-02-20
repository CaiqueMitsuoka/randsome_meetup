class Meetup::Event
  attr_reader :id, :name, :time, :attendded, :venue, :group, :description

  def initialize(event_hash = {}, options = {})
    event_hash.merge!(options)
    @id = event_hash[:id]
    @name = event_hash[:name]
    @time = utc_to_time(event_hash[:time])
    @attendded = event_hash[:yes_rsvp_count]
    @venue = Venue.new(event_hash[:venue])
    @group = Group.new(event_hash[:group])
    @description = event_hash[:description]
  end

  private

  def utc_to_time(utc)
    DateTime.strptime(utc.to_s, '%Q').getlocal
  end
end
