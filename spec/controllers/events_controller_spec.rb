require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:randsome) {
    double('Randsome',
      random_attendee: person,
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

  let(:person) { double('Attendee', name: name, photo: img_name) }

  let(:name) { 'Mary' }

  let(:img_name) { 'image.jpg' }

  let(:event_payload) { { urlname: 'guru-sorocaba', event_id: '1b3b4fe' } }

  before do
    allow_any_instance_of(EventsController).to receive(:meetup).and_return(base_meetup)
    allow_any_instance_of(EventsController).to receive(:randsome).and_return(randsome)
    allow_any_instance_of(Randsome).to receive(:meetup).and_return(base_meetup)
  end

  describe 'GET #index' do
    it 'assign events' do
      get :index
      expect(assigns(:events)).to match_array([])
    end

    it 'call the randsome service' do
      expect(randsome).to receive(:available_events)
      get :index
    end
  end

  describe 'GET #show' do
    it 'assign event' do
      get_event
      expect(assigns(:event)).to match_array({})
    end

    it 'call event of base meetup' do
      expect(base_meetup).to receive(:event).with('guru-sorocaba','1b3b4fe')
      get_event
    end

    def get_event
      get :show, params: event_payload
    end
  end

  describe 'GET #random_attendee' do
    it 'assign attendee' do
      get_random_attendee
      expect(assigns(:person)).to eq(person)
    end

    it 'call attendence of randsome' do
      expect(randsome).to receive(:random_attendee).with('guru-sorocaba','1b3b4fe')
      get_random_attendee
    end

    def get_random_attendee
      get :random_attendee, params: event_payload
    end
  end
end
