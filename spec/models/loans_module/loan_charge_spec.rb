require 'rails_helper'

module LoansModule
  describe LoanCharge do
    describe 'associations' do
      it { is_expected.to have_one :charge_adjustment }
    	it { is_expected.to belong_to :loan }
    	it { is_expected.to belong_to :chargeable }
      it { is_expected.to belong_to :commercial_document }
      it { is_expected.to have_many :loan_charge_payment_schedules }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :loan_id }
      it { is_expected.to validate_presence_of :chargeable_id }
      it { is_expected.to validate_presence_of :chargeable_type }
      it { is_expected.to validate_presence_of :commercial_document_id }
      it { is_expected.to validate_presence_of :commercial_document_type }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:account).to(:chargeable) }
      it { is_expected.to delegate_method(:account_name).to(:chargeable) }
      it { is_expected.to delegate_method(:name).to(:chargeable) }
      it { is_expected.to delegate_method(:amount).to(:chargeable) }
      it { is_expected.to delegate_method(:regular?).to(:chargeable) }
      it { is_expected.to delegate_method(:amortize_balance).to(:charge_adjustment) }
    end
    
    it '.total' do
      loan = create(:loan, loan_amount: 1000)
      charge = create(:charge, charge_type: 'percent_type', percent: 10)
      loan_charge = create(:loan_charge, loan: loan, chargeable: charge)

      expect(LoansModule::LoanCharge.total).to eql(100)
    end

    describe '#charge_amount_with_adjustment' do
      it 'with charge_adjustment' do
        loan = create(:loan, loan_amount: 1000)
        charge = create(:charge, charge_type: 'amount_type', amount: 100)
        loan_charge = create(:loan_charge, loan: loan, chargeable: charge)
        charge_adjustment = create(:charge_adjustment, loan_charge: loan_charge, amount: 55)

        expect(loan_charge.charge_amount_with_adjustment).to eql(55)
      end
      it 'without charge_adjustment' do
        loan = create(:loan, loan_amount: 1000)
        charge = create(:charge, charge_type: 'amount_type', amount: 10)
        loan_charge = create(:loan_charge, loan: loan, chargeable: charge)

        expect(loan_charge.charge_amount_with_adjustment).to eql(10)
      end
    end
  end
end
