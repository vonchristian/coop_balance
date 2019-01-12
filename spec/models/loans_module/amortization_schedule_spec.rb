require 'rails_helper'

module LoansModule
  describe AmortizationSchedule do
    describe 'associations' do
      it { is_expected.to have_many :payment_notices }
    	it { is_expected.to belong_to :loan }
      it { is_expected.to belong_to :loan_application }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to have_many :notes }
      it { is_expected.to belong_to :scheduleable }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :principal }
      it { is_expected.to validate_presence_of :interest }
      it { is_expected.to validate_numericality_of(:principal) }
      it { is_expected.to validate_numericality_of(:interest) }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:borrower).to(:loan) }
      it { is_expected.to delegate_method(:loan_product_name).to(:loan) }
      it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_contact_number).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_address_complete_address).to(:borrower).with_prefix }
    end

    it '.latest' do
      old = create(:amortization_schedule, date: Date.current.last_month)
      latest = create(:amortization_schedule, date: Date.current)

      expect(described_class.latest).to eql latest
      expect(described_class.latest).to_not eql old
    end
  end
end
