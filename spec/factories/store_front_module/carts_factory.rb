FactoryBot.define do
  factory :cart, class: 'StoreFrontModule::Cart' do
    employee factory: %i[teller]
  end
end
