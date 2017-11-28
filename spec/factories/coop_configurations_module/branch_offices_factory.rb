FactoryBot.define do
  factory :branch_office, class: "CoopConfigurationsModule::BranchOffice" do
    sequence(:branch_name) { |n| "Branch Office " +  ('a'..'z').to_a.shuffle.join }
    address "Poblacion"
    contact_number "112312"
    branch_type 'main_office'
    association :cooperative
  end
end
