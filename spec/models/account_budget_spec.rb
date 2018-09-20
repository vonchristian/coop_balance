require 'rails_helper'

describe AccountBudget do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :account }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :account_id }
    it { is_expected.to validate_presence_of :proposed_amount }
    it { is_expected.to validate_presence_of :year }
    it { is_expected.to validate_numericality_of :proposed_amount }
  end

  it ".current" do
    old_budget = create(:account_budget, year: 2017)
    new_budget = create(:account_budget, year: 2019)

    expect(described_class.current).to eql(new_budget)
    expect(described_class.current).to_not eql(old_budget)
  end
end
