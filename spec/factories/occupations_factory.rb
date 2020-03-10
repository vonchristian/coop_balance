FactoryBot.define do 
  factory :occupation do 
    title { Faker::Company.name }
  end 
end 