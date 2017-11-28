FactoryBot.define do
  factory :section, class: "CoopConfigurationsModule::Section" do
    sequence(:name) { |n| "Section " +  ('a'..'z').to_a.shuffle.join }
    description "MyString"
    association :branch_office
  end
end
