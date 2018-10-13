FactoryBot.define do
  factory :time_deposit_application do
    depositor { nil }
    account_number { "MyString" }
    date_deposited { "2018-10-13 13:09:38" }
    term { "9.99" }
    voucher { "" }
  end
end
