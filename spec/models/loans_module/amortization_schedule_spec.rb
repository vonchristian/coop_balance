require 'rails_helper'

module LoansModule
  describe AmortizationSchedule do
    describe 'associations' do
      it { is_expected.to have_many :payment_notices }
    	it { is_expected.to belong_to :loan }
      it { is_expected.to have_many :notes }
    end

    describe '.create_schedule_for(loan)' do
      it 'monthly' do
        monthly_loan = create(:loan, mode_of_payment: 'monthly', term: 36, application_date: Date.today)
        LoansModule::AmortizationSchedule.create_schedule_for(monthly_loan)

        expect(monthly_loan.amortization_schedules.count).to eql 36
      end
      
      it 'quarterly' do
        quarterly_loan = create(:loan, mode_of_payment: 'quarterly', term: 36, application_date: Date.today)
        LoansModule::AmortizationSchedule.create_schedule_for(quarterly_loan)

        expect(quarterly_loan.amortization_schedules.count).to eql 9
      end

      it 'semi_annually' do
        semi_annually_loan = create(:loan, mode_of_payment: 'semi_annually', term: 36, application_date: Date.today)
        LoansModule::AmortizationSchedule.create_schedule_for(semi_annually_loan)

        expect(semi_annually_loan.amortization_schedules.count).to eql 6
      end
    end
  end
end
