FactoryBot.define do
  factory :section, class: "CoopConfigurationsModule::Section" do
    name "MyString"
    description "MyString"
    association :branch_office
  end
end
