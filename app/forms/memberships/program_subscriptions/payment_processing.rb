module Memberships
  module ProgramSubscriptions
    class PaymentProcessing
      include ActiveModel::Model
      attr_accessor :program_subscription_id, :employee_id, :amount, :reference_number, :date, :member_id
      validates :amount, presence: true, numericality: true
      validates :reference_number, :date, presence: true

      def save
        ActiveRecord::Base.transaction do
          save_payment
        end
      end
      private
      def save_payment
        entry = AccountingModule::Entry.create!(
          recorder: find_employee,
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          description: "Payment of #{find_program_subscription.name}",
          reference_number: reference_number,
          commercial_document: find_member,
          entry_date: date,
          debit_amounts_attributes: [
          account: debit_account,
          amount: amount,
          commercial_document: find_program_subscription],
          credit_amounts_attributes: [
          account: credit_account,
          amount: amount,
          commercial_document: find_program_subscription]
        )

      end
      def debit_account
       find_employee.cash_on_hand_account
      end
      def credit_account
        find_program_subscription.account
      end
      def find_program_subscription
        MembershipsModule::ProgramSubscription.find_by_id(program_subscription_id)
      end
      def find_member
        Member.find_by_id(member_id)
      end

      def find_employee
        User.find_by_id(employee_id)
      end
    end
  end
end
