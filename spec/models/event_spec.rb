require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { User.new(username: 'admin') }
  subject(:event) { Event.new(start: Date.today, finish: Date.today + 1.day, timezone: 'CET', creator: user) }
  let!(:events) { create_list(:event, 10)}
  describe 'validations' do
    it 'is valid with valid atributes' do
      expect(event).to be_valid
    end
    it 'is not valid without start date' do
      event.start = nil
      expect(event).to_not be_valid
    end
    it 'is not valid if start before today' do
      event.start = Date.today - 1.day
      expect(event).to_not be_valid
    end
    it 'is valid without a finish date but duration' do
      event.finish = nil
      event.duration = 30
      expect(event).to be_valid
    end
  end
  describe '.state' do
    it 'must be draft at the begining' do
      expect(event.draft?).to eq(true)
      expect(event.state).to eq 'draft'
    end
    it 'cannot be published if any field is blank' do
      expect(event.publishable?).to eq(false)
    end
    it 'can publish if all field are not blank' do
      event.name = 'event1'
      event.description = 'this is a formatted description'
      event.location = 'office 1'
      event.save
      event.publish
      expect(event.state).to eq 'published'
    end
    it 'be soft deleted' do
      
      expect(events.first.destroy.deleted_at).to be
    end
  end
  describe 'Event' do
    it 'can be saved if valid' do
      expect(event.save).to eq(true)
    end
  end
  describe 'Associations' do
    it { is_expected.to belong_to(:creator) }
  end
end
