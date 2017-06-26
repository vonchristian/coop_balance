FactoryGirl.define do
  factory :account, :class => AccountingDepartment::Account do |account|
    account.name
    account.code
    account.contra false
  end

  factory :asset, :class => AccountingDepartment::Asset do |account|
    account.name
    account.code
    account.contra false
  end

  factory :equity, :class => AccountingDepartment::Equity do |account|
    account.name
    account.code
    account.contra false
  end

  factory :expense, :class => AccountingDepartment::Expense do |account|
    account.name
    account.code
    account.contra false
  end

  factory :liability, :class => AccountingDepartment::Liability do |account|
    account.name
    account.code
    account.contra false
  end

  factory :revenue, :class => AccountingDepartment::Revenue do |account|
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