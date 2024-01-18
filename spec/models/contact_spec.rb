require 'rails_helper'

describe Contact, type: :model do
  describe 'associations' do
    it { should belong_to :contactable }
  end

  it '.current' do
    recent_contact = create(:contact, created_at: Time.zone.today)
    old_contact    = create(:contact, created_at: Time.zone.today.last_month)

    expect(described_class.current).to eql recent_contact
    expect(described_class.current).not_to eql old_contact
  end
end
