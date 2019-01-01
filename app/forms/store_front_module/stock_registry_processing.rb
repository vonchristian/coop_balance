module StoreFrontModule
  class StockRegistryProcessing
    include ActiveModel::Model
    attr_accessor :date, :reference_number, :description, :registry_id, :employee_id

    def process!
      ActiveRecord::Base.transaction do
        create_voucher
      end
    end

    private
    def create_voucher
      voucher = Voucher.new(
      account_number: SecureRandom.uuid,
      payee: find_employee,
      preparer: find_employee,
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      description: description,
      reference_number: reference_number,
      date: date
      )
      voucher.voucher_amounts.debit.build(
        cooperative: find_employee.cooperative,
        account: find_employee.store_front.merchandise_inventory_account,
        amount: amount,
        commercial_document: savings_account_application
      )
      voucher.voucher_amounts.credit.build(
        cooperative: find_employee.cooperative,
        account: AccountingModule::Account.find_by(name: "Temporary Merchandise Inventory Account"),
        amount: amount,
        commercial_document: savings_account_application)
      voucher.save!
    end
    def find_employee
      User.find(employee_id)
    end
  end
end
