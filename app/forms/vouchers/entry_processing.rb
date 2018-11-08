module Vouchers
  class EntryProcessing
    include ActiveModel::Model
    attr_reader :voucher, :employee, :updateable
    def initialize(args)
      @voucher    = args[:voucher]
      @employee   = args[:employee]
      @updateable = args[:updateable]
    end
    def process!
      ActiveRecord::Base.transaction do
        create_entry
        update_last_transaction_date
        update_accounts_last_transaction_date
      end
    end
    private
    def create_entry
      entry = AccountingModule::Entry.new(
        cooperative_service: voucher.cooperative_service,
        office:              voucher.office,
        cooperative:         find_cooperative,
        commercial_document: voucher.payee,
        description:         voucher.description,
        recorder:            voucher.preparer,
        reference_number:    voucher.number,
        previous_entry:      find_recent_entry,
        previous_entry_hash: find_recent_entry.encrypted_hash,
        entry_date:          voucher.date)

        voucher.voucher_amounts.debit.each do |amount|
          entry.debit_amounts.build(
            account_id: amount.account_id,
            amount: amount.amount,
            commercial_document: amount.commercial_document)
        end

        voucher.voucher_amounts.credit.each do |amount|
          entry.credit_amounts.build(
            account: amount.account,
            amount: amount.amount,
            commercial_document: amount.commercial_document)
        end
      entry.save!

      voucher.update_attributes!(accounting_entry: entry)
    end

    def update_last_transaction_date
      if updateable.present?
        updateable.update_attributes!(last_transaction_date: voucher.date)
      end
    end

    def update_accounts_last_transaction_date
      voucher.voucher_amounts.accounts.each do |account|
        account.update_attributes!(last_transaction_date: voucher.date)
      end
    end


    def find_recent_entry
      find_cooperative.entries.recent
    end

    def find_cooperative
      voucher.cooperative
    end
  end
end
