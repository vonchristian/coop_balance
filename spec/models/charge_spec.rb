require 'rails_helper'

RSpec.describe Charge, type: :model do
  describe 'associations' do
  	it { is_expected.to belong_to :account }
    it { is_expected.to have_many :loan_charges }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :account_id }
    it { is_expected.to validate_presence_of :charge_type }
    it { is_expected.to validate_numericality_of :amount }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:account).with_prefix }
  end
  describe 'enums' do
    it { is_expected.to define_enum_for(:charge_type).with([:percent_type, :amount_type]) }
  end

  it "#loan_amount_range" do
    charge = create(:charge, depends_on_loan_amount: true, minimum_loan_amount: 10_000, maximum_loan_amount: 100_000)

    expect(charge.loan_amount_range).to eql(10_000..100_000)
  end

  describe '.compute_amount_for(loan)' do
    it 'amount_type' do
      loan = create(:loan, loan_amount: 100_000)
      charge = create(:charge, charge_type: 'amount_type', amount: 100)
      loan_charge = create(:loan_charge, loan: loan, chargeable: charge)

      expect(charge.amount_for(loan)).to eql 100
    end
    it 'percent_type' do
      loan = create(:loan, loan_amount: 100_000)
      charge = create(:charge, charge_type: 'percent_type', percent: 1)
      loan_charge = create(:loan_charge, loan: loan, chargeable: charge)

      expect(charge.amount_for(loan)).to eql 1_000
    end
  end
  it ".amount_for(loan)" do
      loan = create(:loan, loan_amount: 100_000)
      another_loan = create(:loan, loan_amount: 200_000)

      regular_amount_charge = create(:charge, charge_type: 'amount_type', amount: 200)
      regular_percent_charge = create(:charge, charge_type: 'percent_type', percent: 1)
      amount_charge = create(:charge, charge_type: 'amount_type', amount: 100, depends_on_loan_amount: true, minimum_loan_amount: 100_000, maximum_loan_amount: 1_000_000)
      percent_charge = create(:charge, charge_type: 'percent_type', percent: 1, depends_on_loan_amount: true, minimum_loan_amount: 100_000, maximum_loan_amount: 1_000_000)

      regular_amount_loan_charge = create(:loan_charge, loan: another_loan, chargeable: regular_amount_charge)
      regular_percent_loan_charge = create(:loan_charge, loan: another_loan, chargeable: regular_percent_charge)
      amount_loan_charge = create(:loan_charge, loan: loan, chargeable: amount_charge)
      percent_loan_charge = create(:loan_charge, loan: loan, chargeable: percent_charge)

      expect(regular_amount_charge.amount_for(another_loan)).to eql 200
      expect(regular_percent_charge.amount_for(another_loan)).to eql 2_000
      expect(amount_charge.amount_for(loan)).to eql 100
      expect(percent_charge.amount_for(loan)).to eql 1_000
  end

end
