module Registries
  class StockRegistry < Registry

    def parse_for_records
      tmp_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = tmp_spreadsheet.row(2)
      (3..tmp_spreadsheet.last_row).each do |i|
        row = Hash[[header, tmp_spreadsheet.row(i)].transpose]
        upload_product(row)
      end
    end
    private
    def upload_product(row)
      product = StoreFrontModule::Product.find_or_create_by!(
        name: row["Product Name"],
        category: category(row),
        store_front: self.store_front
      )
      
      create_unit_of_measurements(product, row)
      create_purchases(product, row)
    end
    def create_unit_of_measurements(product, row)
      unit_of_measurement = StoreFrontModule::UnitOfMeasurement.create!(
        code: row["Unit of Measurement"],
        product: product,
        base_measurement: row["Base Measurement"] || true,
        base_quantity:  row["Base Quantity"],
        conversion_quantity: row["Conversion Quantity"]
      )

      create_mark_up_price(unit_of_measurement, row)
    end
    def create_purchases(product, row)
      product.purchases.create(
        quantity: row["In Stock"],
        unit_cost: row["Purchase Cost"],
        total_cost: row["Total Cost"]
      )
    end

    def create_mark_up_price(unit_of_measurement, row)
      StoreFrontModule::MarkUpPrice.create!(
      unit_of_measurement: unit_of_measurement,
      date: row["Cut Off Date"],
      price: row["Selling Cost"]
      )
    end

    def category(row)
      cooperative.categories.find_or_create_by!(name: row["Category"])
    end

    def find_cooperative
      employee.cooperative
    end
  end
end
