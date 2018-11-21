require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(username: 'admin') }
  describe 'associations' do
    it { is_expected.to have_many(:events) }
  end
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end
    it 'is not valid without valid attributes' do
      user.username = nil
      expect(user).to_not be_valid
    end
  end
end
