require 'rails_helper'

describe SavingsQuery, type: :model do
  it ".dormant_accounts(days_count)" do
    dormant_saving = create(:saving, updated_at: Date.today)
    active_saving = create(:saving, updated_at: Date.today + 6.months)
    travel_to (Date.today + 6.months) #180 days

    expect(SavingsQuery.new.dormant_accounts(180).pluck(:id)).to include(dormant_saving.id)
    expect(SavingsQuery.new.dormant_accounts(180).pluck(:id)).to_not include(active_saving.id)
  end
end
