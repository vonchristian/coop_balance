require 'rails_helper'

describe Tin do
  describe 'associations' do
    it { is_expected.to belong_to :tinable }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :number }
    it { is_expected.to validate_uniqueness_of(:number).scoped_to(:tinable_id) }
  end

  describe ".current" do
    it "no TIN" do
      expect(described_class.current.class).to eql(NullTin)
    end

    it "with TIN" do
      old_tin = create(:tin, created_at: Date.today.yesterday)
      recent_tin = create(:tin, created_at: Date.today)

      expect(described_class.current).to eql(recent_tin)
      expect(described_class.current).to_not eql(old_tin)
    end
  end
end
