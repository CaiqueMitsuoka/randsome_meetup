class AttendeePresenter < SimpleDelegator
  attr_reader :attendee

  def initialize(attendee)
    @attendee = attendee
    __setobj__(attendee)
  end

  def eql?(target)
    target == self || @attendee.eql?(target)
  end

  def photo
    response = @attendee.photo
    unless response[:photo]
      return ['brown-egg.jpg','white-egg.jpg'].sample
    end
    response[:photo][:photo_link]
  end
end
