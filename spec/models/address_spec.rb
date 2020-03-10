require 'rails_helper'

describe Address do
  describe 'associations' do
  	it { is_expected.to belong_to :addressable }
    it { is_expected.to belong_to(:street).optional }
    it { is_expected.to belong_to(:barangay).optional }
    it { is_expected.to belong_to(:municipality).optional }
    it { is_expected.to belong_to(:province).optional }
  end

  it '.current' do
    current_address = create(:address, current: true)
    not_current_address = create(:address, current: false)

    expect(described_class.current).to include(current_address)
    expect(described_class.current).to_not include(not_current_address)
  end
  it '.recent' do
    recent_address = create(:address, created_at: Date.today)
    old_address = build_stubbed(:address, created_at: Date.today.yesterday)

    expect(described_class.recent).to eql(recent_address)
    expect(described_class.recent).to_not eql(old_address)
  end
end
