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
        cooperative:         find_cooperative,
        commercial_document: find_voucher.payee,
        description:         find_voucher.description,
        recorder:            find_voucher.preparer,
        reference_number:    find_voucher.number,
        previous_entry:      find_recent_entry,
        previous_entry_hash: find_recent_entry.encrypted_hash,
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

      find_voucher.update_attributes!(accounting_entry: entry)
    end

    def find_voucher
      Voucher.find(voucher_id)
    end
    def find_recent_entry
      find_cooperative.entries.recent
    end

    def find_employee
      User.find(employee_id)
    end
    def find_cooperative
      find_voucher.cooperative
    end
  end
end
