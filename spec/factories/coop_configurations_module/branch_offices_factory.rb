FactoryBot.define do
  factory :branch_office, class: "CoopConfigurationsModule::BranchOffice" do
    branch_name { Faker::Name.first_name }
    address "Poblacion"
    contact_number "112312"
    association :cooperative
  end
end
