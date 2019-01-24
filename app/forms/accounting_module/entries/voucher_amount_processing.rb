module AccountingModule
  module Entries
    class VoucherAmountProcessing
      include ActiveModel::Model
      attr_accessor :account_id, :amount, :amount_type, :employee_id, :commercial_document_id, :commercial_document_type

      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      private
      def create_voucher_amount
        Vouchers::VoucherAmount.create!(
          commercial_document: find_commercial_document,
          cooperative: find_employee.cooperative,
          amount_type: amount_type,
          account_id: account_id,
          amount: amount,
          recorder: find_employee
        )
      end

      def find_commercial_document
        if commercial_document_type && commercial_document_id
          commercial_document_type.constantize.find(commercial_document_id)
        else
          find_employee
        end
      end

      def find_employee
        User.find(employee_id)
      end
    end
  end
end
