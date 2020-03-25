FactoryBot.define do
  factory :net_income_config, class: Offices::NetIncomeConfig do
    association :office
    association :net_surplus_account,         factory: :equity
    association :net_loss_account,            factory: :equity
    association :total_revenue_account,       factory: :revenue
    association :total_expense_account,       factory: :expense
    association :interest_on_capital_account, factory: :equity
    book_closing { 'annually' }

    after(:build) do |net_income_config| 
      net_income_config.accounts << net_income_config.net_surplus_account
      net_income_config.accounts << net_income_config.net_loss_account
      net_income_config.accounts << net_income_config.total_revenue_account
      net_income_config.accounts << net_income_config.total_expense_account
      net_income_config.accounts << net_income_config.interest_on_capital_account
    end 
  end
end
