module Memberships
  module ShareCapitals
    class CapitalBuildUpProcessing
      include ActiveModel::Model
      attr_accessor :or_number, :amount, :date, :description, :share_capital_id, :employee_id, :cash_account_id, :account_number

      validates :amount, presence: true, numericality: { greater_than: 0.01 }
      validates :or_number, presence: true

      def save
        ActiveRecord::Base.transaction do
          create_deposit_voucher
          # update_share_capital_status
          # set_last_transaction_date
        end
      end

      def find_voucher
        TreasuryModule::Voucher.find_by(account_number: account_number)
      end

      def find_share_capital
        DepositsModule::ShareCapital.find_by(id: share_capital_id)
      end

      private

      def create_deposit_voucher
        voucher =  TreasuryModule::Voucher.new(
          payee: find_share_capital.subscriber,
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          preparer: find_employee,
          description: description,
          reference_number: or_number,
          account_number: account_number,
          date: date
        )
        voucher.voucher_amounts.debit.build(
          account: cash_account,
          amount: amount
        )
        voucher.voucher_amounts.credit.build(
          account: credit_account,
          amount: amount
        )
        voucher.save!
      end

      def cash_account
        AccountingModule::Account.find(cash_account_id)
      end

      def credit_account
        find_share_capital.share_capital_equity_account
      end

      def find_subscriber
        find_share_capital.subscriber
      end

      def find_employee
        User.find(employee_id)
      end
    end
  end
end
