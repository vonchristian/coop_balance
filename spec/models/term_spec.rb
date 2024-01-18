require 'rails_helper'

describe Term do
  describe 'associations' do
    it { should belong_to :termable }
  end

  describe 'validations' do
    it { should validate_presence_of :effectivity_date }
    it { should validate_presence_of :number_of_days }
    it { should validate_numericality_of :number_of_days }
  end

  describe 'delegations' do
    it { should delegate_method(:disbursed?).to(:termable) }
  end

  it 'NUMBER_OF_DAYS_IN_MONTH' do
    expect(described_class::NUMBER_OF_DAYS_IN_MONTH).to eq 30
  end

  it '.past_due' do
    past_due_term = create(:term, term: 1, effectivity_date: Time.zone.today, maturity_date: Time.zone.today + 1.month)
    current_term  = create(:term, term: 12, effectivity_date: Time.zone.today, maturity_date: Time.zone.today + 12.months)
    travel_to Time.zone.today + 31.days

    expect(described_class.past_due).to include(past_due_term)
    expect(described_class.past_due).not_to include(current_term)
  end

  it '.current' do
    create(:term, effectivity_date: Time.zone.today.last_month)
    current_term = create(:term, effectivity_date: Time.zone.today)

    expect(described_class.current).to eql current_term
  end

  it '#matured?' do
    term = create(:term, term: 30, effectivity_date: Time.zone.today, maturity_date: Time.zone.today + 30.days)
    travel_to Time.zone.today + 31.days

    expect(term.matured?).to be true
  end

  it '#past_due?' do
    term = create(:term, term: 30, effectivity_date: Time.zone.today, maturity_date: Time.zone.today + 30.days)
    travel_to Time.zone.today + 32.days

    expect(term.past_due?).to be true
  end
end
