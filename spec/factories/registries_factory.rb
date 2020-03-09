FactoryBot.define do 
  factory :registry do 
    association :cooperative
    association :office 
    association :employee

    factory :loan_registry, class: Registries::LoanRegistry do 
      type { "Registries::LoanRegistry" }
      after(:build) do |reg|
        reg.spreadsheet.attach(io: File.open(Rails.root.join('spec', 'support', 'registries', 'loan_registry.xlsx')), filename: "loan_registry.xlsx", content_type: "application/vnd.ms-office")
      end 
    end 
  end 
end 