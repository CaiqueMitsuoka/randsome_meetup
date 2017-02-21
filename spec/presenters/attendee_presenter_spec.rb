require 'rails_helper'

RSpec.describe AttendeePresenter, type: :presenter do
  let(:attendee_presenter) {
    AttendeePresenter.new(attendee)
  }

  let(:attendee) {
    double('Attendee', id: '2abde12', name: 'Foo', photo: {})
  }

  let(:attendee) {
    double('Attendee', id: '2abde12', name: 'Foo', photo: { photo: { photo_link: photo_link }})
  }

  let(:photo_link) { 'http://api.meetup.com/' }

  describe '#photo' do
    context 'the attendee does not have one' do
      let(:attendee) {
        double('Attendee', id: '2abde12', name: 'Foo', photo: {})
      }

      it 'return one egg photo' do
        expect(attendee_presenter.photo).to include('egg.jpg')
      end
    end

    context 'the attende has a photo' do
      it 'return the photo link' do
        expect(attendee_presenter.photo).to eq(photo_link)
      end
    end
  end

  describe '#eql?' do
    context 'equal' do
      it 'to the presenter' do
        result = attendee_presenter.eql?(attendee_presenter)
        expect(result).to be_truthy
      end

      it 'to the attendee' do
        result = attendee_presenter.eql?(AttendeePresenter.new(attendee))
        expect(result).to be_truthy
      end
    end

    context 'different' do
      it 'to the presenter' do
        result = attendee_presenter.eql?(AttendeePresenter.new(double('Attendee')))
        expect(result).to be_falsy
      end
    end
  end
end
