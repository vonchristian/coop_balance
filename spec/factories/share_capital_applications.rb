FactoryBot.define do
  factory :share_capital_application do
    subscriber { nil }
    share_capital_product { nil }
    cooperative { nil }
    office { nil }
    initial_capital { "9.99" }
    account_number { "MyString" }
    date_opened { "2018-10-23 09:31:28" }
  end
end
