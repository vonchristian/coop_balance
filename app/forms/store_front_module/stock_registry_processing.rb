module StoreFrontModule
  class StockRegistryProcessing
    include ActiveModel::Model
    attr_accessor :spreadsheet, :voucher_account_number, :employee_id, :date, :store_front_id, :cooperative_id
    def process!
      ActiveRecord::Base.transaction do
        save_stock_registry
        create_voucher
      end
    end
    private
    def save_stock_registry
      registry = Registries::StockRegistry.create!(
        store_front: find_store_front,
        spreadsheet: spreadsheet,
        employee_id: employee_id,
        cooperative: find_cooperative
        date: date
      )
      registry.parse_for_records
    end

    def create_voucher
      Voucher.new(
        cooperative: find_cooperative,
        date: date,
        account_number: voucher_account_number,
        description: "Forwarded balance of Merchandise Inventory #{find_store_front.name}",
      )
    end

    def find_store_front
      find_cooperative.find(store_front_id)
    end

    def find_cooperative
      find_employee.cooperative
    end

    def find_employee
      User.find(employee_id)
    end
  end
end
