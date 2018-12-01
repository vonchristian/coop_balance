require 'rails_helper'

describe Address do
  describe 'associations' do
  	it { is_expected.to belong_to :addressable }
    it { is_expected.to belong_to :street }
    it { is_expected.to belong_to :barangay }
    it { is_expected.to belong_to :municipality }
    it { is_expected.to belong_to :province }
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

  describe '.current_address' do
    it '#with no address' do
      expect(described_class.current_address.class).to eql(NullAddress)
    end

    it '#with address' do
      not_current_address    = create(:address, current: false)
      recent_current_address = create(:address, current: true, created_at: Date.today)
      old_current_address    = create(:address, current: true, created_at: Date.today.yesterday)

      expect(described_class.current_address).to eql(recent_current_address)
      expect(described_class.current_address).to_not eql(old_current_address)
      expect(described_class.current_address).to_not eql(not_current_address)
    end
  end
end
