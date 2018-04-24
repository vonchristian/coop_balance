require 'rails_helper'

describe Term do
  describe 'associations' do
    it { is_expected.to belong_to :termable }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :term }
    it { is_expected.to validate_numericality_of :term }
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
