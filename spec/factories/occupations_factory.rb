FactoryBot.define do
  factory :occupation do
    title { Faker::Company.profession }
  end
end
