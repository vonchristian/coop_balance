require 'rails_helper'

RSpec.describe Occupation, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
  end

  describe ".recent" do
    it 'with occupation' do
      recent_occupation = create(:occupation, created_at: Date.today)
      old_occupation    = create(:occupation, created_at: Date.today.last_month)

      expect(described_class.recent).to eql(recent_occupation)
      expect(described_class.recent).to_not eql(old_occupation)
    end
    it 'with no occuaption' do
      expect(described_class.recent.class).to eql(NullOccupation)
    end
  end

end
