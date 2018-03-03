module Memberships
  module ProgramSubscriptions
    class PaymentProcessing
      include ActiveModel::Model
      attr_accessor :program_subscription_id, :recorder_id, :amount, :or_number, :date, :membership_id
      validates :amount, presence: true, numericality: true
      validates :or_number, presence: true

      def save
        ActiveRecord::Base.transaction do
          save_payment
        end
      end
      private
      def save_payment
        AccountingModule::Entry.create(
          recorder: find_employee,
          description: 'Payment of program subscription',
          reference_number: or_number,
          commercial_document: find_membership,
          entry_date: date,
          debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: find_program_subscription],
          credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: find_program_subscription]
        )
      end
      def debit_account
       find_employee.cash_on_hand_account
      end
      def credit_account
        find_program_subscription.account
      end
      def find_program_subscription
        MembershipsModule::ProgramSubscription.find_by(id: program_subscription_id)
      end
      def find_membership
        Membership.find_by_id(membership_id)
      end

      def find_employee
        User.find_by_id(recorder_id)
      end
    end
  end
end
