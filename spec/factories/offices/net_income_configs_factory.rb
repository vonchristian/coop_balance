FactoryBot.define do
  factory :net_income_config, class: Offices::NetIncomeConfig do
    association :office
    association :net_income_account, factory: :equity
    book_closing { 'annually' }
  end
end
