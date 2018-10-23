module Vouchers
  class DisbursementProcessing
    include ActiveModel::Model
    attr_accessor :voucher_id, :employee_id

    def process!
      ActiveRecord::Base.transaction do
        create_entry
      end
    end
    private
    def create_entry
      entry = AccountingModule::Entry.new(
        cooperative_service: find_voucher.cooperative_service,
        office:              find_voucher.office,
        cooperative:         find_voucher.cooperative,
        commercial_document: find_voucher.payee,
        description:         find_voucher.description,
        recorder:            find_voucher.preparer,
        reference_number:    find_voucher.number,
        entry_date:          find_voucher.date)

        find_voucher.voucher_amounts.debit.each do |amount|
          entry.debit_amounts.build(
            account_id: amount.account_id,
            amount: amount.amount,
            commercial_document: amount.commercial_document)
        end

        find_voucher.voucher_amounts.credit.each do |amount|
          entry.credit_amounts.build(
            account: amount.account,
            amount: amount.amount,
            commercial_document: amount.commercial_document)
        end
      entry.save!
      entry.set_previous_entry!
      entry.set_hashes!
    end

    def find_voucher
      Voucher.find(voucher_id)
    end
    
    def find_employee
      User.find(employee_id)
    end
  end
end
