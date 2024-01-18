FactoryBot.define do
  factory :cash_count_report do
    employee { nil }
    date { '2019-03-05 20:00:20' }
    beginning_balance { '9.99' }
    ending_balance { '9.99' }
    difference { '9.99' }
    description { 'MyString' }
  end
end
