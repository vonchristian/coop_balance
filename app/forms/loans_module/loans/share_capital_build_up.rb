module LoansModule
  module Loans
    class ShareCapitalBuildUp
      include ActiveModel::Model
      attr_accessor :amount, :loan_id, :share_capital_id, :employee_id
      validates :amount, numericality: true, presence: true
      def add_to_loan_charges!
        ActiveRecord::Base.transaction do
          save_loan_charge
        end
      end

      private
      def save_loan_charge
        capital_build_up = Charge.amount_type.create(
        name: "Capital Build Up",
        amount: amount,
        account: find_share_capital.share_capital_product_paid_up_account)
        find_loan.loan_charges.find_or_create_by(
        charge: capital_build_up,
        commercial_document: find_share_capital,
        amount_type: 'credit')
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
      def find_share_capital
        MembershipsModule::ShareCapital.find_by_id(share_capital_id)
      end
    end
  end
end
