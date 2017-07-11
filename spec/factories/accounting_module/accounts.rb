FactoryGirl.define do
  factory :account, :class => AccountingModule::Account do |account|
    account.name
    account.code
    account.contra false
  end

  factory :asset, :class => AccountingModule::Asset do |account|
    account.name
    account.code
    account.contra false
  end

  factory :equity, :class => AccountingModule::Equity do |account|
    account.name
    account.code
    account.contra false
  end

  factory :expense, :class => AccountingModule::Expense do |account|
    account.name
    account.code
    account.contra false
  end

  factory :liability, :class => AccountingModule::Liability do |account|
    account.name
    account.code
    account.contra false
  end

  factory :revenue, :class => AccountingModule::Revenue do |account|
    account.name
    account.code
    account.contra false
  end

  sequence :name do |n|
    "Factory Name #{n}"
  end
  sequence :code do |n|
    "#{n}000#{n}#{n}"
  end
end