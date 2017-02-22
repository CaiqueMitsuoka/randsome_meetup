require 'rails_helper'

RSpec.describe Meetup::Event, type: :model do
  let(:id) { 'B12A87E' }
  let(:name) { 'Party' }
  let(:time) { 1487709706836 }
  let(:attendded) { 30 }
  let(:venue) { {} }
  let(:group) { {} }
  let(:description) { 'All your base are belong to us' }
  let(:event_hosts) { ['Irineu', 'Douglas'] }

  let(:params_hash) {
    {
      id: id,
      name: name,
      time: time,
      yes_rsvp_count: attendded,
      venue: venue,
      group: group,
      description: description,
      event_hosts: event_hosts
    }
  }

  let(:event) { Meetup::Event.new(params_hash) }

  let(:venue_double) { double('Venue') }

  let(:group_double) { double('Group') }

  before do
    allow(Meetup::Group).to receive(:new).and_return(group_double)
    allow(Meetup::Venue).to receive(:new).and_return(venue_double)
  end


  it_behaves_like 'instance has attribute',
                  Meetup::Event.new(id: 'B12A87E'),
                  :id,
                  'B12A87E'

  it_behaves_like 'instance has attribute',
                  Meetup::Event.new(name: 'Party'),
                  :name,
                  'Party'

  it_behaves_like 'instance has attribute',
                  Meetup::Event.new(time: 1487709706836),
                  :time,
                  DateTime.strptime('1487709706836', '%Q').getlocal

  it_behaves_like 'instance has attribute',
                  Meetup::Event.new(yes_rsvp_count: 30),
                  :attendded,
                  30

  it_behaves_like 'instance has attribute',
                  Meetup::Event.new(event_hosts: 30),
                  :event_hosts,
                  30

  context '#venue' do
    it 'returns the double of Meetup::Venue' do
      expect(event.venue).to eq(venue_double)
    end
  end

  context '#group' do
    it 'returns the double of Meetup::Group' do
      expect(event.group).to eq(group_double)
    end
  end

  context '#month' do
    it 'call #month of time' do
      expect(event.time).to receive(:month).and_call_original
      event.month
    end

    it 'call #t of I18n' do
      expect(I18n).to receive(:t).with("date.abbr_month_names").and_call_original
      event.month
    end
  end

  shared_examples 'delegate to event#time' do |name, value|
    @name = name.to_s

    context "##{@name}" do
      it "return #{value} as a #{@name}" do
        expect(event.send(name)).to eq(value)
      end

      it "call ##{@name} of time" do
        expect(event.time).to receive(name)
        event.send(name)
      end
    end
  end

  include_examples 'delegate to event#time', :year, 2017

  include_examples 'delegate to event#time', :day, 21
end
