FactoryBot.define do
  factory :contact do
    association :contactable, factory: :member
  end
end 
