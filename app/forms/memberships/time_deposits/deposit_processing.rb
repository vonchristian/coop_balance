module Memberships
  module TimeDeposits
    class DepositProcessing
      include ActiveModel::Model
      attr_accessor :reference_number, :account_number, :date, :amount,:depositor_id, :employee_id, :number_of_days, :time_deposit_product_id
      validates :depositor_id,
                :date,
                :amount,
                :reference_number,
                presence: true
      validates :amount,
                :number_of_days,
                numericality: true

      def susbscribe!
        ActiveRecord::Base.transaction do
          create_time_deposit
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
          depositor: find_depositor,
          account_number: account_number,
          date_deposited: date,
          time_deposit_product_id: time_deposit_product_id)
        TimeDepositsModule::FixedTerm.create!(
          time_deposit: time_deposit,
          number_of_days: number_of_days,
          deposit_date: date,
          maturity_date: (date.to_date + (number_of_days.to_i.days)))
        create_entry(time_deposit)
      end

      def find_employee
        User.find_by_id(employee_id)
      end

      def create_entry(time_deposit)
        AccountingModule::Entry.create!(
        origin: find_employee.office,
        commercial_document: find_depositor,
        recorder: find_employee,
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
    end
  end
end
