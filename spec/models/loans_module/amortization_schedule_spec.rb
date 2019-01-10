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
      it { is_expected.to validate_numericality_of(:principal).is_greater_than(0.01) }
      it { is_expected.to validate_numericality_of(:interest).is_greater_than(0.01) }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:borrower).to(:loan) }
      it { is_expected.to delegate_method(:loan_product_name).to(:loan) }
      it { is_expected.to delegate_method(:name).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_contact_number).to(:borrower).with_prefix }
      it { is_expected.to delegate_method(:current_address_complete_address).to(:borrower).with_prefix }
    end


    describe '.create_schedule_for(loan)' do
      it 'monthly' do
        monthly_loan = create(:loan_application, mode_of_payment: 'monthly',  application_date: Date.today, term: 36)
        LoansModule::AmortizationSchedule.create_amort_schedule_for(monthly_loan)

        expect(monthly_loan.amortization_schedules.count).to eql 36
      end

      it 'quarterly' do
        quarterly_loan = create(:loan_application, mode_of_payment: 'quarterly',  application_date: Date.today, term: 16)
        LoansModule::AmortizationSchedule.create_amort_schedule_for(quarterly_loan)

        expect(quarterly_loan.amortization_schedules.count).to eql 4
      end

      it 'semi_annually' do
        semi_annually_loan = create(:loan_with_interest_on_loan_charge, mode_of_payment: 'semi_annually', application_date: Date.today)
        term = create(:term, termable: semi_annually_loan, term: 6)
        LoansModule::AmortizationSchedule.create_schedule_for(semi_annually_loan)

        expect(semi_annually_loan.amortization_schedules.count).to eql 6
      end
    end
    describe '.interest_computation' do
      it 'has_prededucted_interest' do
        amortization_schedule = create(:amortization_schedule, has_prededucted_interest: true)

        expect(amortization_schedule.interest_computation).to eql 0
      end

      it 'has no prededucted interest' do
        amortization_schedule = create(:amortization_schedule, has_prededucted_interest: false)

        expect(amortization_schedule.interest_computation).to eql amortization_schedule.interest
      end
    end
  end
end
