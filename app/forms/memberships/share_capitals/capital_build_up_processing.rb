module Memberships
  module ShareCapitals
    class CapitalBuildUpProcessing
      include ActiveModel::Model
      attr_accessor :or_number, :amount, :date, :share_capital_id, :employee_id, :cash_account_id, :account_number
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
        Voucher.find_by(account_number: account_number)
      end

      def find_share_capital
        MembershipsModule::ShareCapital.find_by_id(share_capital_id)
      end


      private
      def create_deposit_voucher
        voucher = Voucher.new(
          payee:          find_share_capital.subscriber,
          office:         find_employee.office,
          cooperative:    find_employee.cooperative,
          preparer:       find_employee,
          description:    "Capital build up transaction of #{find_share_capital.subscriber.full_name}",
          reference_number: or_number,
          account_number: account_number,
          date: date)
        voucher.voucher_amounts.debit.build(
          account: cash_account,
          amount: amount,
          commercial_document: find_share_capital)
        voucher.voucher_amounts.credit.build(
          account: credit_account,
          amount: amount,
          commercial_document: find_share_capital)
        voucher.save!
      end

      def cash_account
        AccountingModule::Account.find(cash_account_id)
      end

      def credit_account
        find_share_capital.share_capital_product_paid_up_account
      end

      def find_subscriber
        find_share_capital.subscriber
      end

      def find_employee
        User.find_by_id(employee_id)
      end

    end
  end
end
