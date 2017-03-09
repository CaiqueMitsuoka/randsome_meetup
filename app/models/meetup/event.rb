class Meetup::Event
  attr_reader :id, :name, :time, :attendded, :venue, :group, :description, :event_hosts

  def initialize(event_hash = {}, options = {})
    event_hash = {} if event_hash.nil?
    event_hash.merge!(options)
    @id = event_hash[:id]
    @name = event_hash[:name]
    @time = utc_to_time(event_hash[:time])
    @attendded = event_hash[:yes_rsvp_count]
    @venue = Meetup::Venue.new(event_hash[:venue])
    @group = Meetup::Group.new(event_hash[:group])
    @description = event_hash[:description]
    @event_hosts = event_hash[:event_hosts]
  end

  def day
    @time.day
  end

  def month
    I18n.t("date.abbr_month_names")[@time.month]
  end

  def year
    @time.year
  end

  private

  def utc_to_time(utc)
    if utc.nil?
      DateTime.now
    else
      DateTime.strptime(utc.to_s, '%Q').getlocal
    end
  end
end
