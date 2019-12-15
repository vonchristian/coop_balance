FactoryBot.define do
  factory :cart, class: StoreFrontModule::Cart do
    association :employee, factory: :teller
  end
end
