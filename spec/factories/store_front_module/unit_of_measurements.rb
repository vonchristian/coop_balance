FactoryBot.define do
  factory :unit_of_measurement, class: "StoreFrontModule::UnitOfMeasurement" do
    product nil
    code "kg"
    description "MyString"
    quantity 1
    conversion_quantity 50
    base_measurement false

    factory :base_measurement do
      base_measurement true
    end
    factory :measurement_with_conversion_multiplier do
      base_measurement false
      conversion_quantity 50
    end
  end
end
