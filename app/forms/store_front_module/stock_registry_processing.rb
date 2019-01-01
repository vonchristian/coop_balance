module StoreFrontModule
  class StockRegistryProcessing
    include ActiveModel::Model
    attr_accessor :date, :reference_number, :description, :registry_id, :employee_id

    def process!
      ActiveRecord::Base.transaction do
        upload_stocks
      end
    end

    private
    def upload_stocks
      find_registry.temporary_products.each do |temporary_product|
        create_or_find_product(temporary_product)
        create_or_find_unit_of_measurement(temporary_product)
        create_or_find_mark_up_price(temporary_product)
        create_or_find_purchase_line_items(temporary_product)
      end
    end

    def create_or_find_product(temporary_product)
      find_cooperative.products.find_or_create_by(name: temporary_product.name, category: find_category(temporary_product))
    end
    def create_or_find_unit_of_measurement(temporary_product)
      create_or_find_product.unit_of_measurements.find_or_create_by(
        unit_code: temporary_product.unit_of_measurement,
        unit_cost:
      )
    def find_category(temporary_product)
      find_cooperative.categories.find_by(name: temporary_product.category_name)
    end
  end
end
