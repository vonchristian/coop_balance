FactoryBot.define do
  factory :registry do
    cooperative
    office
    employee

    factory :loan_registry, class: 'Registries::LoanRegistry' do
      type { 'Registries::LoanRegistry' }
      after(:build) do |reg|
        reg.spreadsheet.attach(io: Rails.root.join('spec/support/registries/loan_registry.xlsx').open, filename: 'loan_registry.xlsx', content_type: 'application/vnd.ms-office')
      end
    end
  end
end