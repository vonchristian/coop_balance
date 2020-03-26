module Vouchers
  class EntryProcessing
    include ActiveModel::Model
    attr_reader :voucher, :employee, :updateable, :cooperative
    def initialize(args)
      @voucher     = args[:voucher]
      @employee    = args[:employee]
      @cooperative = @employee.try(:cooperative)
    end
    def process!
      ActiveRecord::Base.transaction do
        create_entry
        remove_cart_reference
      end
    end

    private
    def create_entry
      entry = AccountingModule::Entry.new(
        origin:              voucher.origin,  
        recording_agent:     voucher.recording_agent,
        office:              voucher.office,
        cooperative:         cooperative,
        commercial_document: voucher.payee,
        description:         voucher.description,
        recorder:            voucher.preparer,
        reference_number:    voucher.reference_number,
        ref_number_integer:  voucher.reference_number.to_i,
        entry_date:          voucher.date,
        entry_time:          (voucher.date.strftime('%B %e, %Y').to_s + " " + voucher.created_at.to_s).to_datetime)

      voucher.voucher_amounts.debit.each do |amount|
        entry.debit_amounts.build(
          account:             amount.account,
          amount:              amount.amount
        )
      end

      voucher.voucher_amounts.credit.each do |amount|
        entry.credit_amounts.build(
          account:             amount.account,
          amount:              amount.amount
        )
      end

      entry.save!
      voucher.update!(accounting_entry: entry, disburser: employee)
    end

   
    def remove_cart_reference
      voucher.voucher_amounts.each do |amount|
        amount.update(cart_id: nil)
      end
    end 
  end
end
