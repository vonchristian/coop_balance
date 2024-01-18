FactoryBot.define do
  factory :saving, class: 'DepositsModule::Saving' do
    cooperative
    office
    depositor factory: %i[member]
    saving_product
    liability_account factory: %i[liability]
    interest_expense_account factory: %i[expense]
    account_number { SecureRandom.uuid }
    after(:save) do |saving|
      saving.accounts << saving.liability_account
      saving.accounts << saving.interest_expense_account
    end
  end
end
