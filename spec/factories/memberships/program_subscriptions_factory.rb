FactoryBot.define do
  factory :program_subscription, class: 'MembershipsModule::ProgramSubscription' do
    program
    subscriber factory: %i[member]
    program_account factory: %i[asset]
    office
    account_number { SecureRandom.uuid }
  end
end
