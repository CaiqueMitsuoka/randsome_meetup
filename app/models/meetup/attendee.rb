class Meetup::Attendee
  attr_reader :id, :name

  def initialize(attendee_hash = {}, options = {})
    attendee_hash = {} if attendee_hash.nil?
    attendee_hash.merge!(options)
    @id = attendee_hash[:id]
    @name = attendee_hash[:name]
  end

  def photo
    BaseMeetup.new.profile_image(@id)
  end
end
