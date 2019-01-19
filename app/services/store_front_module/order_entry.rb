module StoreFrontModule
  class OrderEntry
    attr_reader :voucher, :order, :store_front, :employee

    def initialize(args)
      @voucher = args.fetch(:voucher)
      @order   = args.fetch(:order)
      @store_front = @order.store_front
      @employee = @order.employee
    end

    def create_entry
      entry = AccountingModule::Entry.new(
        cooperative:         voucher.cooperative,
        office:              voucher.office,
        recorder:            voucher.preparer,
        previous_entry:      voucher.cooperative.entries.recent,
        commercial_document: voucher.payee,
        entry_date:          voucher.date,
        description:         voucher.description,
      )
      voucher.voucher_amounts.debit.each do |debit_amount|
        entry.debit_amounts.build(
        amount:              debit_amount.amount,
        account:             debit_amount.account,
        commercial_document: debit_amount.commercial_document)
      end

      voucher.voucher_amounts.credit.each do |credit_amount|
        entry.credit_amounts.build(
        amount:              credit_amount.amount,
        account:             credit_amount.account,
        commercial_document: credit_amount.commercial_document)
      end
      entry.save!
      voucher.update_attributes!(accounting_entry: entry)
    end
  end
end
