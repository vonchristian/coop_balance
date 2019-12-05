FactoryBot.define do
  factory :office_program, class: Offices::OfficeProgram do
    association :program
    association :office
    association :level_one_account_category, factory: :asset_level_one_account_category
  end
end
