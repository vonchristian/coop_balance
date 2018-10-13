module Memberships
  module TimeDeposits
    class DepositProcessing
      include ActiveModel::Model
      attr_accessor :reference_number, :account_number, :date, :amount,
      :depositor_id, :employee_id, :term, :time_deposit_product_id,
      :cash_account_id, :voucher_account_number
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
        end
      end
      def find_voucher
        Voucher.find_by(account_number: voucher_account_number)
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
        create_voucher(time_deposit)
      end

      def find_employee
        User.find_by_id(employee_id)
      end

      def create_voucher(time_deposit)
        voucher = Voucher.new(
          account_number: voucher_account_number,
          payee: find_depositor,
          preparer: find_employee,
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          description: 'Time deposit',
          number: reference_number,
          date: date
        )
        voucher.voucher_amounts.debit.build(
          account: cash_account,
          amount: amount,
          commercial_document: time_deposit
        )
        voucher.voucher_amounts.credit.build(
          account: credit_account,
          amount: amount,
          commercial_document: time_deposit)
        voucher.save!
      end

      def credit_account
        find_time_deposit_product.account
      end
      def cash_account
        AccountingModule::Account.find(cash_account_id)
      end

      def find_time_deposit_product
        CoopServicesModule::TimeDepositProduct.find_by_id(time_deposit_product_id)
      end
    end
  end
end
