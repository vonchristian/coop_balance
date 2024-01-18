module Registries
  class StockRegistry < Registry
    has_many :temporary_products, class_name: 'StockRegistryTemporaryProduct'

    def parse_for_records
      product_spreadsheet = Roo::Spreadsheet.open(spreadsheet.path)
      header = product_spreadsheet.row(2)
      (3..product_spreadsheet.last_row).each do |i|
        row = [header, product_spreadsheet.row(i)].transpose.to_h
        create_temp_product(row)
      end
    end

    def create_temp_product(row)
      temporary_products.create!(
        cooperative: cooperative,
        employee: employee,
        store_front: employee.store_front,
        product_name: row['Product Name'],
        category_name: row['Category'],
        unit_of_measurement: row['Unit of Measurement'],
        in_stock: row['In Stock'],
        purchase_cost: row['Purchase Cost'],
        total_cost: row['Total Cost'],
        selling_cost: row['Selling Cost'],
        barcodes: row['Barcodes'].split(','),
        base_measurement: row['Base Measurement'],
        base_quantity: row['Base Quantity'],
        conversion_quantity: row['Conversion Quantity'],
        date: DateTime.parse(row['Cut-off Date'].strftime('%B %e, %Y'))
      )
    end
  end
end
