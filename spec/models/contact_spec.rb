require 'rails_helper'

describe Contact, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :contactable }
  end

  it ".current" do
    recent_contact = create(:contact, created_at: Date.today)
    old_contact    = create(:contact, created_at: Date.today.last_month)

    expect(described_class.current).to eql recent_contact
    expect(described_class.current).to_not eql old_contact
  end
end
