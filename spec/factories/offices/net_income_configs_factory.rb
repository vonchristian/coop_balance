FactoryBot.define do
  factory :net_income_config, class: 'Offices::NetIncomeConfig' do
    office
    net_surplus_account factory: %i[equity]
    net_loss_account factory: %i[equity]
    total_revenue_account factory: %i[revenue]
    total_expense_account factory: %i[expense]
    interest_on_capital_account factory: %i[equity]
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
