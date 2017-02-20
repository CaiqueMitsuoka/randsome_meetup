class Meetup::Venue
  attr_reader :name, :address_1, :city, :country, :localized_country_name

  def initialize(venue_hash = {}, options = {})
    venue_hash.merge!(options)
    @name = venue_hash[:name]
    @address_1 = venue_hash[:address_1]
    @city = venue_hash[:city]
    @country = venue_hash[:country]
    @localized_country_name = venue_hash[:localized_country_name]
  end

  def country_name
    @localized_country_name
  end
end
