module AccountingModule
  class LevelThreeAccountCategory < ApplicationRecord
    class_attribute :normal_credit_balance
    extend AccountingModule::UpdatedAtFinder
    include PgSearch::Model
    pg_search_scope :text_search, against: [:title, :code]

    belongs_to :office,                     class_name: 'Cooperatives::Office'
    has_many :level_two_account_categories, class_name: 'AccountingModule::LevelTwoAccountCategory'
    has_many :accounts,                     through: :level_two_account_categories, class_name: 'AccountingModule::Account'
    has_many :amounts,                      through: :accounts, class_name: 'AccountingModule::Amount'
    has_many :debit_amounts,                through: :accounts, class_name: 'AccountingModule::DebitAmount'
    has_many :credit_amounts,               through: :accounts, class_name: 'AccountingModule::CreditAmount'
    has_many :entries,                      through: :accounts, class_name: 'AccountingModule::Entry'
    has_many :debit_entries,                through: :accounts, class_name: 'AccountingModule::Entry'
    has_many :credit_entries,               through: :accounts, class_name: 'AccountingModule::Entry'

    validates :title, :code, presence: true, uniqueness: { scope: :office_id }
    validates :type, presence: true


    scope :assets,      -> { where(type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Asset') }
    scope :liabilities, -> { where(type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Liability') }
    scope :equities,    -> { where(type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Equity') }
    scope :revenues,    -> { where(type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Revenue') }
    scope :expenses,    -> { where(type: 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Expense') }

    def self.level_two_account_categories
      ids = []
      self.all.each do |category|
        ids << category.level_two_account_categories.ids
      end
      AccountingModule::LevelTwoAccountCategory.where(id: ids.compact.flatten.uniq)
    end

    def self.except_cash_account_categories
      where.not(id: Employees::EmployeeCashAccount.cash_account_categories.ids)
    end

    def self.types
      ["AccountingModule::AccountCategories::LevelThreeAccountCategories::Asset",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Equity",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Liability",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Expense",
       "AccountingModule::AccountCategories::LevelThreeAccountCategories::Revenue"]
    end

    def normalized_type
      type.gsub("AccountingModule::AccountCategories::LevelThreeAccountCategories::", "")
    end

    def self.trial_balance(args={})
      return raise(NoMethodError, "undefined method 'trial_balance'") unless self.new.class == AccountingModule::LevelThreeAccountCategory
        assets.balance(args) -
        (liabilities.balance(args) +
        equities.balance(args) +
        revenues.balance(args) -
        expenses.balance(args))
    end

    def self.balance(options={})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        if category.contra?
          accounts_balance -= category.balance(options)
        else
          accounts_balance += category.balance(options)
        end
      end
      accounts_balance
    end

    def self.debits_balance(options={})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        if account.contra?
          accounts_balance -= category.debits_balance(options)
        else
          accounts_balance += category.debits_balance(options)
        end
      end
      accounts_balance
    end

    def self.credits_balance(options={})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        if account.contra?
          accounts_balance -= category.credits_balance(options)
        else
          accounts_balance += category.credits_balance(options)
        end
      end
      accounts_balance
    end

    def balance(options={})
      return raise(NoMethodError, "undefined method 'balance'") if self.class == AccountingModule::LevelThreeAccountCategory
      if self.normal_credit_balance ^ contra
        credits_balance(options) - debits_balance(options)
      else
        debits_balance(options) - credits_balance(options)
      end
    end

    def credits_balance(args={})
      credit_amounts.balance(args)
    end

    def debits_balance(args={})
      debit_amounts.balance(args)
    end
  end
end
