FactoryBot.define do
  factory :office_loan_product_aging_group, class: LoansModule::OfficeLoanProductAgingGroup do
    association :office_loan_product
    association :loan_aging_group
    association :level_one_account_category, factory: :asset_level_one_account_category
  end
end
