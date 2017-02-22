  require 'rails_helper'

RSpec.describe Meetup::Attendee, type: :model do
  let(:attendee) {
    Meetup::Attendee.new(
    id: id,
    name: name
    )
  }

  let(:name) { 'Irineu' }

  let(:id) { '123456' }

  describe '#initialize' do
    context 'options overide initial hash' do
      let(:expected_id) { '456' }

      let(:expected_name) { 'Irineu' }

      let(:attendee) {
        Meetup::Attendee.new(
          {
            id: '123',
            name: 'Foo'
          },
          id: expected_id,
          name: expected_name
        )
      }

      it 'overide id' do
        expect(attendee.id).to eq(expected_id)
      end

      it 'overide name' do
        expect(attendee.name).to eq(expected_name)
      end
    end
  end

  context '#photo' do
    let(:img) { 'img.jpg' }

    before do
      allow_any_instance_of(BaseMeetup).to receive(:profile_image).with(id).and_return(img)
    end

    it 'call BaseMeetup#profile_image with id' do
      expect(attendee.photo).to eq(img)
    end
  end

  it_behaves_like 'instance has attribute',
                  Meetup::Attendee.new(name: 'Irineu'),
                  :name,
                  'Irineu'

  it_behaves_like 'instance has attribute',
                  Meetup::Attendee.new(id: '123456'),
                  :id,
                  '123456'
end
