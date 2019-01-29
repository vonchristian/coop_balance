FactoryBot.define do
  factory :registry do
    date { "2017-10-02 18:24:14" }
    spreadsheet { "" }
  end
  factory :loan_registry, class: Registries::LoanRegistry do
  end
end
