require 'rails_helper'

module LoansModule
  describe LoanCharge do
    describe 'associations' do
      it { is_expected.to have_one :charge_adjustment }
    	it { is_expected.to belong_to :loan }
    	it { is_expected.to belong_to :chargeable }
      it { is_expected.to have_many :loan_charge_payment_schedules }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :loan_id }
      it { is_expected.to validate_presence_of :chargeable_id }
      it { is_expected.to validate_presence_of :chargeable_type }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:account).to(:chargeable) }
      it { is_expected.to delegate_method(:account_name).to(:chargeable) }
      it { is_expected.to delegate_method(:name).to(:chargeable) }
      it { is_expected.to delegate_method(:amount).to(:chargeable) }
      it { is_expected.to delegate_method(:regular?).to(:chargeable) }
      it { is_expected.to delegate_method(:amortize_balance).to(:charge_adjustment) }
    end
    describe '#charge_amount' do
      it 'as a percent type' do
        #returns 10% of loan amount
        loan = create(:loan, loan_amount: 1000)
        charge = create(:charge, charge_type: 'percent_type', percent: 10)
        loan_charge = create(:loan_charge, loan: loan, chargeable: charge)

        expect(loan_charge.charge_amount).to eql(100)
      end
      it 'as an amount type' do
         loan = create(:loan, loan_amount: 1000)
        charge = create(:charge, charge_type: 'amount_type', amount: 10)
        loan_charge = create(:loan_charge, loan: loan, chargeable: charge)

        expect(loan_charge.charge_amount).to eql(10)
      end
    end
  end
end
