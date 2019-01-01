FactoryBot.define do
  factory :stock_registry_temporary_product do
    product_name { "MyString" }
    category_name { "MyString" }
    unit_of_measurement { "MyString" }
    in_stock { "9.99" }
    purchase_cost { "9.99" }
    total_cost { "9.99" }
    selling_cost { "9.99" }
    barcodes { "" }
    base_measurement { false }
    base_quantity { "9.99" }
    conversion_quantity { "9.99" }
    store_front { nil }
    cooperative { nil }
    employee { nil }
    date { "2018-12-27 15:49:43" }
  end
end
