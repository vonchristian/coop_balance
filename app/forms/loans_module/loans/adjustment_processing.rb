module LoansModule
  module Loans
    class AdjustmentProcessing
      include ActiveModel::Model
      attr_accessor :loan_charge_id, :loan_id, :amount, :percent, :amortize_balance, :number_of_payments, :employee_id

      def save
        ActiveRecord::Base.transaction do
          create_adjustment
          update_amortization_schedule
        end
      end

      private
      def create_adjustment
        find_loan_charge.create_charge_adjustment!(
          amount: amount,
          percent: percent,
          amortize_balance: amortize_balance,
          number_of_payments: number_of_payments
          )
      end
      def find_loan_charge
        LoansModule::LoanCharge.find_by_id(loan_charge_id)
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end

      def update_amortization_schedule
        LoansModule::AmortizationSchedule.create_schedule_for(find_loan)
      end


      def find_employee
        User.find(employee_id)
      end

    end
  end
end
