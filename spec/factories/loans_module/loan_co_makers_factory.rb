FactoryBot.define do 
  factory :loan_co_maker, class: LoansModule::LoanCoMaker do 
    association :loan 
    association :co_maker, factory: :member 
  end 
end 