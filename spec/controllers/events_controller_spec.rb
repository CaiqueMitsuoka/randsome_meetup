require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:randsome) {
    double('Randsome',
      random_attendee: { id: 'A41F1E1', name: name },
      available_events: []
    )
  }

  let(:base_meetup) {
    double('BaseMeetup',
      self_events: [],
      event: {},
      attendance: [{ member: person }],
      profile_image: img_name
    )
  }

  let(:person) {
    {
      name: name,
      photo: {
        thumb: img_name
      }
    }
  }

  let(:name) { 'Mary' }

  let(:img_name) { 'image.jpg' }

  let(:event_payload) { { urlname: 'guru-sorocaba', event_id: '1b3b4fe' } }

  before do
    allow_any_instance_of(EventsController).to receive(:meetup).and_return(base_meetup)
    allow_any_instance_of(EventsController).to receive(:randsome).and_return(randsome)
    allow_any_instance_of(Randsome).to receive(:meetup).and_return(base_meetup)
  end

  describe 'GET #index' do
    before do
      base_meetup = double('BaseMeetup', self_events: [])
      allow_any_instance_of(EventsController).to receive(:meetup).and_return(base_meetup)
    end

    it 'assign events' do
      get :index
      expect(assigns(:events)).to match_array([])
    end
  end

  describe 'GET #show' do
    before do
      @base_meetup = double('BaseMeetup', event: {})
      allow_any_instance_of(EventsController).to receive(:meetup).and_return(@base_meetup)
    end

    it 'assign event' do
      get_event
      expect(assigns(:event)).to match_array({})
    end

    it 'call event of base meetup' do
      expect(@base_meetup).to receive(:event).with('guru-sorocaba','1b3b4fe')
      get_event
    end

    def get_event
      get :show, params: { urlname: 'guru-sorocaba', event_id: '1b3b4fe' }
    end
  end

  describe 'GET #random_attendee' do
    let(:name) { 'Mary' }
    let(:img_name) { 'image.jpg' }

    before do
      person = {
        name: name,
        photo: {
          thumb: img_name
        }
      }
      @base_meetup = double('BaseMeetup', attendance: [{ member: person }])
      allow_any_instance_of(EventsController).to receive(:meetup).and_return(@base_meetup)
    end

    it 'assign image' do
      get_random_attendee
      expect(assigns(:image)).to eq(img_name)
    end

    it 'assign name' do
      get_random_attendee
      expect(assigns(:name)).to eq(name)
    end

    it 'call attendence of base meetup' do
      expect(@base_meetup).to receive(:attendance).with('guru-sorocaba','1b3b4fe')
      get_random_attendee
    end

    def get_random_attendee
      get :random_attendee, params: { urlname: 'guru-sorocaba', event_id: '1b3b4fe' }
    end
  end
end
