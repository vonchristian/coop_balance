module StoreFrontModule
  module Suppliers
    class VoucherProcessing
      include ActiveModel::Model
      attr_accessor :date, :description, :account_number, :reference_number, :supplier_id, :preparer_id

      validates :date, :description, :reference_number, :account_number, :supplier_id, :preparer_id, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_voucher
          remove_voucher_amount_reference
        end
      end

      def find_voucher
        find_cooperative.vouchers.find_by(account_number: account_number)
      end

      private

      def create_voucher
        voucher = find_cooperative.vouchers.create!(
          payee: find_supplier,
          office: find_employee.office,
          date: date,
          reference_number: reference_number,
          description: description,
          preparer: find_employee,
          account_number: account_number,
          number:  TreasuryModule::Voucher.generate_number
        )
        voucher.voucher_amounts << find_supplier.voucher_amounts
      end

      def find_supplier
        find_cooperative.suppliers.find(supplier_id)
      end

      def find_cooperative
        find_employee.cooperative
      end

      def find_employee
        User.find(preparer_id)
      end

      def remove_voucher_amount_reference
        find_supplier.voucher_amounts.each do |voucher_amount|
          voucher_amount.commercial_document_id = nil
          voucher_amount.commercial_document_type = nil
          voucher_amount.save
        end
      end
    end
  end
end
