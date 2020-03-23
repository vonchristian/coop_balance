FactoryBot.define do
  factory :net_income_config, class: Offices::NetIncomeConfig do
    association :office
    association :net_surplus_account,         factory: :equity
    association :net_loss_account,            factory: :equity
    association :total_revenue_account,       factory: :revenue
    association :total_expense_account,       factory: :expense
    association :interest_on_capital_account, factory: :equity
    book_closing { 'annually' }
  end
end
