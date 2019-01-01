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
      find_cooperative.products.find_or_create_by(
        name: temporary_product.product_name,
        category: find_category(temporary_product))
    end
    def create_or_find_unit_of_measurement(temporary_product)
      create_or_find_product(temporary_product).unit_of_measurements.find_or_create_by(
        code: temporary_product.unit_of_measurement,
        base_measurement: temporary_product.base_measurement,
        base_quantity: temporary_product.base_quantity,
        conversion_quantity: temporary_product.conversion_quantity
      )
    end

    def find_category(temporary_product)
      find_cooperative.categories.find_by(name: temporary_product.category_name)
    end
    def create_or_find_mark_up_price(temporary_product)
      create_or_find_unit_of_measurement(temporary_product).mark_up_prices.create(
        price: temporary_product.selling_cost,
        date: temporary_product.date
      )
    end
    def create_or_find_purchase_line_items(temporary_product)
      line_item = create_or_find_product(temporary_product).purchases.create(
        forwarded: true,
        quantity: temporary_product.in_stock,
        unit_cost: temporary_product.purchase_cost,
        total_cost: temporary_product.total_cost,
      )
      create_barcodes(line_item, temporary_product)
    end

    def create_barcodes(line_item, temporary_product)
      temporary_product.barcodes.each do |barcode|
        Barcode.create(
        code: barcode,
        barcodeable: line_item)
      end
    end
    def find_registry
      find_cooperative.stock_registries.find(registry_id)
    end
    def find_cooperative
      find_employee.cooperative
    end
    def find_employee
      User.find(employee_id)
    end
  end
end
