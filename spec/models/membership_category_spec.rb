require 'rails_helper'

describe MembershipCategory, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it 'validate_uniqueness_of(:title).scoped_to(:cooperative_id)' do
      cooperative = create(:cooperative)
      create(:membership_category, title: 'Test Category', cooperative: cooperative)
      category    = build(:membership_category, title: 'Test Category', cooperative: cooperative)
      category.save

      expect(category.errors[:title]).to eq ['has already been taken']
    end
  end
end
