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
    it { is_expected.to validate_uniqueness_of(:year).scoped_to(:account_id) }
  end

  it ".current" do
    old_budget = create(:account_budget, year: 2017)
    new_budget = create(:account_budget, year: 2019)

    expect(described_class.current).to eql(new_budget)
    expect(described_class.current).to_not eql(old_budget)
  end

  it ".for_year(args={})" do
    first_year = create(:account_budget, year: 2018, proposed_amount: 2000)
    second_year = create(:account_budget, year: 2019, proposed_amount: 1500)

    expect(described_class.for_year(year: 2018)).to eql first_year
    expect(described_class.for_year(year: 2018)).to_not eql second_year
  end


  it ".variance_amount(args={})" do
    first_year = create(:account_budget, year: 2018, proposed_amount: 2000)
    second_year = create(:account_budget, year: 2019, proposed_amount: 1500)

    expect(described_class.variance_amount(first_year: first_year, second_year: second_year)).to eql 500
  end

end
