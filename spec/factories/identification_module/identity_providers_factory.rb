FactoryBot.define do
  factory :identity_provider, class: 'IdentificationsModule::IdentityProvider' do
    name { 'MyString' }
  end
end
