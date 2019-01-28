FactoryBot.define do
  factory :office, class: "Cooperatives::Office" do
    sequence(:name) { |n| "Office " +  ('a'..'z').to_a.shuffle.join }
    address { "Poblacion" }
    contact_number { "112312" }
    association :cooperative
    factory :main_office, class: Cooperatives::Offices::MainOffice do
      type "Cooperatives::Offices::MainOffice"
    end
  end
end
