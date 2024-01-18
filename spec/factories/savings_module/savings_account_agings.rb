FactoryBot.define do
  factory :savings_account_aging, class: 'SavingsModule::SavingsAccountAging' do
    savings_account factory: %i[saving]
    savings_aging_group
    date { Date.current }
  end
end
