require 'rails_helper'

describe Address do
  describe 'associations' do
    it { should belong_to :addressable }
    it { should belong_to(:street).optional }
    it { should belong_to(:barangay).optional }
    it { should belong_to(:municipality).optional }
    it { should belong_to(:province).optional }
  end

  it '.current' do
    current_address = create(:address, current: true)
    not_current_address = create(:address, current: false)

    expect(described_class.current).to include(current_address)
    expect(described_class.current).not_to include(not_current_address)
  end

  it '.recent' do
    recent_address = create(:address, created_at: Time.zone.today)
    old_address = build_stubbed(:address, created_at: Time.zone.today.yesterday)

    expect(described_class.recent).to eql(recent_address)
    expect(described_class.recent).not_to eql(old_address)
  end
end
