require 'rails_helper'

RSpec.describe Meetup::Venue, type: :model do
  describe '#initialize' do
    let(:name) { 'Irineu' }
    let(:address_1) { 'Alameda dos anjos' }
    let(:city) { 'sorocaba' }
    let(:country) { 'brazil' }
    let(:localized_country_name) { 'br' }

    let(:venue) { Meetup::Venue.new(name: name,
      address_1: address_1,
      city: city,
      country: country,
      localized_country_name: localized_country_name)
    }

    describe '#country_name' do
      it 'call @localized_country_name' do
        expect(venue.country_name).to eq(localized_country_name)
      end
    end
  end

  it_behaves_like 'instance has attribute',
                  Meetup::Venue.new(name: 'Room 1-1'),
                  :name,
                  'Room 1-1'

  it_behaves_like 'instance has attribute',
                  Meetup::Venue.new(address_1: 'Alameda dos anjos'),
                  :address_1,
                  'Alameda dos anjos'

  it_behaves_like 'instance has attribute',
                  Meetup::Venue.new(city: 'Sorocaba'),
                  :city,
                  'Sorocaba'

  it_behaves_like 'instance has attribute',
                  Meetup::Venue.new(country: 'BR'),
                  :country,
                  'BR'

  it_behaves_like 'instance has attribute',
                  Meetup::Venue.new(localized_country_name: 'Brasil'),
                  :localized_country_name,
                  'Brasil'
end
