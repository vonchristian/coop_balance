FactoryBot.define do
  factory :share_capital, class: 'DepositsModule::ShareCapital' do
    office
    cooperative
    subscriber factory: %i[member]
    share_capital_equity_account factory: %i[equity]
    share_capital_product
    account_number     { SecureRandom.uuid }
    account_owner_name { Faker::Name.name }

    after(:commit) do |share|
      share.accounts << share.share_capital_equity_account
    end
  end
end
