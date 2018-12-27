FactoryBot.define do
  factory :office, class: "CoopConfigurationsModule::Office" do
    sequence(:name) { |n| "Office " +  ('a'..'z').to_a.shuffle.join }
    address { "Poblacion" }
    contact_number { "112312" }
    association :cooperative
  end
end
