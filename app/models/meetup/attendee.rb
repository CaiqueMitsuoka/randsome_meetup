class Meetup::Attendee
  attr_reader :id, :name

  def initialize(attendee_hash = {}, options = {})
    attendee_hash.merge!(options)
    @id = attendee_hash[:id]
    @name = attendee_hash[:name]
  end

  def photo
    response = BaseMeetup.new.profile_image(@id)
    unless response[:photo]
      return ['brown-egg.jpg','white-egg.jpg'].sample
    end
    response[:photo][:photo_link]
  end
end
