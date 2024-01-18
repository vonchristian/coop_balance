module StoreFrontModule
  class StockRegistryVoucherProcessing
    attr_reader :registry

    def initialize(args)
      @registry = args[:registry]
    end

    def create_voucher
      voucher = Voucher.new(
        account_number: voucher_account_number,
        payee: find_employee,
        commercial_document: registry,
        preparer: find_employee,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        description: "Forwarded merchandise invetory (#{find_store_front.name})",
        reference_number: 'SYSTEM',
        date: date
      )
      voucher.voucher_amounts.debit.build(
        cooperative: find_employee.cooperative,
        account: find_store_front.merchandise_inventory_account,
        amount: amount,
        commercial_document: find_store_front
      )
      voucher.voucher_amounts.credit.build(
        cooperative: find_employee.cooperative,
        account: find_cooperative.accounts.find_by(name: 'Temporary Merchandise Inventory Account'),
        amount: amount,
        commercial_document: find_store_front
      )
      voucher.save!
    end
  end
end
