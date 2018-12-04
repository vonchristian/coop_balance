module AccountingModule
  module Entries
    class VoucherAmountProcessing
      include ActiveModel::Model
      attr_accessor :account_id, :amount, :amount_type, :employee_id

      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      private
      def create_voucher_amount
        Vouchers::VoucherAmount.create!(
          cooperative: find_employee.cooperative,
          amount_type: amount_type,
          account_id: account_id,
          amount: amount,
          commercial_document: find_employee,
          recorder: find_employee
        )
      end
      def find_employee
        User.find(employee_id)
      end
    end
  end
end
