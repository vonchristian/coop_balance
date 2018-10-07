module Memberships
  module TimeDeposits
    class DepositProcessing
      include ActiveModel::Model
      attr_accessor :reference_number, :account_number, :date, :amount,:depositor_id, :employee_id, :term, :time_deposit_product_id
      validates :depositor_id,
                :date,
                :amount,
                :reference_number,
                presence: true
      validates :amount,
                :term,
                numericality: true

      def susbscribe!
        ActiveRecord::Base.transaction do
          create_time_deposit
          set_last_transaction_date
        end
      end
      def find_time_deposit
        find_depositor.time_deposits.find_by(account_number: account_number)
      end

      def find_depositor
        employee_depositor = User.find_by_id(depositor_id)
        member_depositor = Member.find_by_id(depositor_id)
        if employee_depositor.present?
          employee_depositor
        elsif member_depositor.present?
          member_depositor
        end
      end

      private
      def create_time_deposit
        time_deposit = MembershipsModule::TimeDeposit.create!(
          depositor_name: find_depositor.full_name,
          depositor: find_depositor,
          account_number: account_number,
          date_deposited: date,
          time_deposit_product_id: time_deposit_product_id)
          Term.create!(
          termable: time_deposit,
          term: term,
          effectivity_date: date,
          maturity_date: (date.to_date + (term.to_i.months)))
        create_entry(time_deposit)
      end

      def find_employee
        User.find_by_id(employee_id)
      end

      def create_entry(time_deposit)
        AccountingModule::Entry.create!(
        commercial_document: find_depositor,
        recorder: find_employee,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        description: 'Time deposit',
        reference_number: reference_number,
        entry_date: date,
        debit_amounts_attributes: [
          account: find_employee.cash_on_hand_account,
          amount: amount,
          commercial_document: time_deposit],
        credit_amounts_attributes: [
          account: credit_account,
          amount: amount,
          commercial_document: time_deposit])
      end
      def credit_account
        find_time_deposit_product.account
      end
      def find_time_deposit_product
        CoopServicesModule::TimeDepositProduct.find_by_id(time_deposit_product_id)
      end
      def set_last_transaction_date
        find_time_deposit.update_attributes!(last_transaction_date: date)
        find_time_deposit.depositor.update_attributes!(last_transaction_date: date)
      end
    end
  end
end
