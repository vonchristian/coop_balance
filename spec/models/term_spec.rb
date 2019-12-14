require 'rails_helper'

describe Term do
  describe 'associations' do
    it { is_expected.to belong_to :termable }
  end 
  describe 'validations' do
    it { is_expected.to validate_presence_of :effectivity_date }
    it { is_expected.to validate_presence_of :number_of_days }
    it { is_expected.to validate_numericality_of :number_of_days }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:disbursed?).to(:termable) }
  end

  it ".past_due" do
    past_due_term = create(:term, term: 1, effectivity_date: Date.today, maturity_date: Date.today + 1.month)
    current_term = create(:term, term: 12, effectivity_date: Date.today, maturity_date: Date.today + 12.month)
    travel_to Date.today + 31.days

    expect(described_class.past_due).to include(past_due_term)
    expect(described_class.past_due).to_not include(current_term)

  end

  it ".current" do
    old_term = create(:term, effectivity_date: Date.today.last_month)
    current_term = create(:term, effectivity_date: Date.today)

    expect(described_class.current).to eql current_term
  end
  it "#matured?" do
    term = create(:term, term: 1, effectivity_date: Date.today, maturity_date: Date.today + 1.month)
    travel_to Date.today + 31.days

    expect(term.matured?).to be true
  end
end
