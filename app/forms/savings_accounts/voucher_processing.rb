module SavingsAccounts
  class VoucherProcessing
    include ActiveModel::Model
    attr_accessor :voucher_id

    def process!
      ActiveRecord::Base.transaction do
        create_entry
      end
    end

    private
    def create_entry
      entry = AccountingModule::Entry.new(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        commercial_document: find_voucher,
        description:         find_voucher.description,
        reference_number:    find_voucher.number,
        recorder:            find_employee,
        entry_date: find_voucher.date)
      find_voucher.voucher_amounts.debit.each do |amount|
        debit_amount = AccountingModule::DebitAmount.new(
          account: amount.account,
          amount: amount.amount,
          commercial_document: amount.commercial_document)
        entry.debit_amounts << debit_amount
      end
      find_voucher.voucher_amounts.credit.each do |amount|
        credit_amount = AccountingModule::CreditAmount.new(
          account: amount.account,
          amount: amount.amount,
          commercial_document: amount.commercial_document)
        entry.credit_amounts << credit_amount
      end
      entry.save!
      set_voucher_entry(entry)
    end

    def set_voucher_entry(entry)
      find_voucher.update_attributes!(entry_id: entry.id)
    end

    def find_employee
      find_voucher.preparer
    end
    def find_voucher
      Voucher.find(voucher_id)
    end
  end
end
