FactoryBot.define do
  factory :membership, class: 'Cooperatives::Membership' do
    cooperator factory: %i[member]
    cooperative
    office
    membership_category
    account_number { SecureRandom.uuid }
  end
end
