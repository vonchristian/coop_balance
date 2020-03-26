module AccountingModule
  class LevelOneAccountCategory < ApplicationRecord
    class_attribute :normal_credit_balance
    extend AccountingModule::UpdatedAtFinder
    include PgSearch::Model
    pg_search_scope :text_search, against: [:title, :code]

    belongs_to :level_two_account_category, class_name: 'AccountingModule::LevelTwoAccountCategory', optional: true
    belongs_to :office,                     class_name: 'Cooperatives::Office', optional: true 
    belongs_to :categorizeable,             polymorphic: true 
    has_many :accounts,                     class_name: 'AccountingModule::Account', dependent: :nullify
    has_many :amounts,                      through: :accounts, class_name: 'AccountingModule::Amount'
    has_many :debit_amounts,                through: :accounts, class_name: 'AccountingModule::DebitAmount'
    has_many :credit_amounts,               through: :accounts, class_name: 'AccountingModule::CreditAmount'
    has_many :entries,                      through: :accounts, class_name: 'AccountingModule::Entry'
    has_many :debit_entries,                through: :accounts, class_name: 'AccountingModule::Entry'
    has_many :credit_entries,               through: :accounts, class_name: 'AccountingModule::Entry'

    validates :title, :code, presence: true, uniqueness: { scope: :office_id }
    validates :type, presence: true

    scope :assets,      -> { where(type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Asset') }
    scope :liabilities, -> { where(type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Liability') }
    scope :equities,    -> { where(type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Equity') }
    scope :revenues,    -> { where(type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Revenue') }
    scope :expenses,    -> { where(type: 'AccountingModule::AccountCategories::LevelOneAccountCategories::Expense') }
    
    def self.updated_at(args={})
      date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
      joins(:entries).where('entries.entry_date' => date_range.start_date..date_range.end_date)
    end

    def self.except_cash_account_categories
      where.not(id: Employees::EmployeeCashAccount.cash_account_categories.ids)
    end

    def self.types
      ["AccountingModule::AccountCategories::LevelOneAccountCategories::Asset",
       "AccountingModule::AccountCategories::LevelOneAccountCategories::Equity",
       "AccountingModule::AccountCategories::LevelOneAccountCategories::Liability",
       "AccountingModule::AccountCategories::LevelOneAccountCategories::Expense",
       "AccountingModule::AccountCategories::LevelOneAccountCategories::Revenue"]
    end

    def normalized_type
      type.gsub("AccountingModule::AccountCategories::LevelOneAccountCategories::", "")
    end

    def self.trial_balance(args={})
      return raise(NoMethodError, "undefined method 'trial_balance'") unless self.new.class == AccountingModule::LevelOneAccountCategory
        assets.balance(args) -
        (liabilities.balance(args) +
        equities.balance(args) +
        revenues.balance(args) -
        expenses.balance(args))
    end

    def self.balance(args = {})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        if category.contra?
          accounts_balance -= category.balance(args)
        else
          accounts_balance += category.balance(args)
        end
      end
      accounts_balance
    end

    def self.debits_balance(args = {})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        if category.contra?
          accounts_balance -= category.debits_balance(args)
        else
          accounts_balance += category.debits_balance(args)
        end
      end
      accounts_balance
    end

    def self.credits_balance(args = {})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        if category.contra?
          accounts_balance -= category.credits_balance(args)
        else
          accounts_balance += category.credits_balance(args)
        end
      end
      accounts_balance
    end

    def balance(options={})
      if self.class == AccountingModule::LevelOneAccountCategory
        raise(NoMethodError, "undefined method 'balance'")
      else
        if self.normal_credit_balance ^ contra?
          credits_balance(options) - debits_balance(options)
        else
          debits_balance(options) - credits_balance(options)
        end
      end
    end

    def credits_balance(args = {})
      credit_amounts.balance(args)
    end

    def debits_balance(args = {})
      debit_amounts.balance(args)
    end
  end
end
