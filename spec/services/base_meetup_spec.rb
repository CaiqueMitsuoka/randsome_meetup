require 'rails_helper'
require 'securerandom'

RSpec.describe BaseMeetup, type: :service do
  let(:random_hash_key) { SecureRandom.hex }

  let(:random_refresh_key) { SecureRandom.hex }

  let(:session_double) {
    {
      token: random_hash_key,
      refresh_token: random_refresh_key
    }
  }

  describe 'GET on Meetup.com API' do
    let(:return_payload_array) {
      '[{
        "event_hosts":"someone",
        "time":1487709706836
      }]'
    }

    let(:return_payload) {
      '{
        "time":1487709706836
      }'
    }

    let(:urlname) { 'randsome-meetup' }

    let(:event_id) { '2a2be4d' }

    context '#event' do
      before do
        @meetup = generate_base_meetup(return_payload)
      end

      it 'call #get with urlname and event_id' do
        expect(@meetup).to receive(:get).with("/#{urlname}/events/#{event_id}")
        @meetup.event(urlname, event_id)
      end

      it 'call #parse_json_array' do
        expect(@meetup).to receive(:parse_json).with(return_payload).and_call_original
        @meetup.event(urlname, event_id)
      end

      context 'convert the payload to an object' do
        it 'call Meetup::Event#new with the payload' do
          expected_with = JSON.parse(return_payload).symbolize_keys
          expect(Meetup::Event).to receive(:new).with(expected_with)
          @meetup.event(urlname, event_id)
        end
      end
    end

    context '#self_events' do
      before do
        @meetup = generate_base_meetup(return_payload_array)
      end

      it 'call #get with desc true' do
        expect(@meetup).to receive(:get).with('/self/events?desc=true&fields=event_hosts')
        @meetup.self_events()
      end

      it 'call #get with desc false' do
        expect(@meetup).to receive(:get).with('/self/events?desc=false&fields=event_hosts')
        @meetup.self_events(false)
      end

      it 'call #parse_json_array' do
        expect(@meetup).to receive(:parse_json_array).with(return_payload_array).and_return([])
        @meetup.self_events()
      end

      context 'convert the payload to a collection' do
        let(:payload) {
          [
            {
              key1: 'value1'
            },
            {
              key2: 'value2'
            }
          ]
        }
        before do
          allow(@meetup).to receive(:parse_json_array).and_return(payload)
        end

        it 'maps the api response' do
          expect(payload).to receive(:map)
          @meetup.self_events()
        end

        it 'create new Meetup::Event for every item in payload' do
          expect(Meetup::Event).to receive(:new).exactly(payload.length).times
          @meetup.self_events()
        end
      end
    end

    context '#attendance' do
      before do
        @meetup = generate_base_meetup(return_payload_array)
      end

      it 'call #get with attendance url' do
        expect(@meetup).to receive(:get).with("/#{urlname}/events/#{event_id}/attendance")
        @meetup.attendance(urlname, event_id)
      end

      it 'call #parse_json_array' do
        expect(@meetup).to receive(:parse_json_array).with(return_payload_array).and_return([])
        @meetup.attendance(urlname, event_id)
      end

      context 'convert the payload to a collection' do
        let(:payload) {
          [
            {
              key1: 'value1'
            },
            {
              key2: 'value2'
            }
          ]
        }
        before do
          allow(@meetup).to receive(:parse_json_array).and_return(payload)
        end

        it 'maps the api response' do
          expect(payload).to receive(:map)
          @meetup.attendance(urlname, event_id)
        end

        it 'create new Meetup::Event for every item in payload' do
          expect(Meetup::Attendee).to receive(:new).exactly(payload.length).times
          @meetup.attendance(urlname, event_id)
        end
      end
    end

    describe '#get' do
      before do
        @meetup ||= BaseMeetup.new(session_double)
      end

      context 'request to the API is valid' do
        let(:meetup_key) { SecureRandom.hex }

        let(:meetup_secret) { SecureRandom.hex }

        let(:new_token) { SecureRandom.hex }

        let(:new_refresh_token) { SecureRandom.hex }

        let(:credentials_payload) {
          "{
            \"access_token\": \"#{new_token}\",
            \"refresh_token\": \"#{new_refresh_token}\"
          }"
        }

        before do
          allow(ENV).to receive(:[]).with('MEETUP_KEY').and_return(meetup_key)
          allow(ENV).to receive(:[]).with('MEETUP_SECRET').and_return(meetup_secret)
          allow(RestClient).to receive(:post).and_return(credentials_payload)
        end

        it 'call RestClient#post' do
          expect(RestClient).to receive(:post).with(
          'https://secure.meetup.com/oauth2/access?' +
          "client_id=#{meetup_key}" +
          "&client_secret=#{meetup_secret}" +
          '&grant_type=refresh_token' +
          "&refresh_token=#{random_refresh_key}", nil)
          @meetup.refresh_session_token
        end

        it 'assigns a new token' do
          @meetup.refresh_session_token
          expect(@meetup.instance_variable_get(:@token)).to eq(new_token)
        end

        it 'assigns a new refresh token' do
          @meetup.refresh_session_token
          expect(@meetup.instance_variable_get(:@refresh_token)).to eq(new_refresh_token)
        end
      end

      context 'request to the API is unauthorized' do
        before do
          allow(@meetup).to receive(:refresh_session_token)
          allow(RestClient).to receive(:get).and_raise(RestClient::Unauthorized)
        end

        it('call #refresh_session_token') do
          expect(@meetup).to receive(:refresh_session_token)
          @meetup.get('')
        end

        it('call #refresh_session_token only once') do
          expect(@meetup).to receive(:refresh_session_token).exactly(1).times
          @meetup.get('')
        end

        it('call RestClient#get twice') do
          expect(RestClient).to receive(:get).exactly(2).times
          @meetup.get('')
        end
      end
    end
  end

  def generate_base_meetup(return_value = {})
    meetup = BaseMeetup.new(session_double)
    allow(meetup).to receive(:get).and_return(return_value)
    meetup
  end
end
