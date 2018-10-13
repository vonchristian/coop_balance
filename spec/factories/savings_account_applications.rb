FactoryBot.define do
  factory :savings_account_application do
    depositor { nil }
    saving_product { nil }
    date_opened { "2018-10-13 14:48:52" }
    initial_deposit { "9.99" }
    account_number { "MyString" }
  end
end
