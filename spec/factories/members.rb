FactoryBot.define do
  factory :member, aliases: [:borrower] do
    first_name "MyString"
    middle_name "MyString"
    last_name "MyString"
    sex 1
    date_of_birth "2017-06-06"
  end
end
