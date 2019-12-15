module Vouchers
  class EntryProcessing
    include ActiveModel::Model
    attr_reader :voucher, :employee, :updateable, :cooperative
    def initialize(args)
      @voucher     = args[:voucher]
      @employee    = args[:employee]
      @cooperative = @employee.cooperative
      @updateable  = args[:updateable]
    end
    def process!
      ActiveRecord::Base.transaction do
        create_entry
        update_last_transaction_date
        update_accounts_last_transaction_date
        remove_cart_reference
      end
    end

    private
    def create_entry
      entry = AccountingModule::Entry.new(
        cooperative_service: voucher.cooperative_service,
        office:              voucher.office,
        cooperative:         cooperative,
        commercial_document: voucher.payee,
        description:         voucher.description,
        recorder:            voucher.preparer,
        reference_number:    voucher.reference_number,
        entry_date:          voucher.date
      )

      voucher.voucher_amounts.debit.each do |amount|
        entry.debit_amounts.build(
          account:             amount.account,
          amount:              amount.amount,
          commercial_document: amount.commercial_document
        )
      end

      voucher.voucher_amounts.credit.each do |amount|
        entry.credit_amounts.build(
          account:             amount.account,
          amount:              amount.amount,
          commercial_document: amount.commercial_document
        )
      end

      entry.save!
      voucher.update!(accounting_entry: entry, disburser: employee)
    end

    def update_last_transaction_date
      # if updateable.present?
      #   updateable.update_attributes!(last_transaction_date: voucher.date)
      #   if updateable.try(:depositor).present?
      #     updateable.depositor.update_attributes!(last_transaction_date: voucher.date)
      #   end
      #   if updateable.try(:subscriber).present?
      #     updateable.subscriber.update_attributes!(last_transaction_date: voucher.date)
      #   end
      # end
    end

    def update_accounts_last_transaction_date
      voucher.voucher_amounts.accounts.each do |account|
        account.update!(last_transaction_date: voucher.date)
      end
    end
    def remove_cart_reference
      voucher.voucher_amounts.each do |amount|
        amount.update(cart_id: nil)
      end
    end 
  end
end
