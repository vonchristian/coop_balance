FactoryBot.define do
  factory :share_capital, class: MembershipsModule::ShareCapital do
    association        :office
    association        :cooperative
    association        :subscriber, factory: :member
    association        :share_capital_equity_account, factory: :equity
    association        :share_capital_product
    account_number     { SecureRandom.uuid }
    account_owner_name { Faker::Name.name }
    
    after(:build) do |share| 
      share.accounts << share.share_capital_equity_account
    end 
  end
end
