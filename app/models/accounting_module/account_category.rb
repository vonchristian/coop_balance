#use to consolidate accounts into a single category
module AccountingModule
  class AccountCategory < ApplicationRecord
    class_attribute :normal_credit_balance
    extend AccountingModule::UpdatedAtFinder
    include PgSearch::Model
    pg_search_scope :text_search, against: [:title, :code]

    belongs_to :cooperative
    belongs_to :office, class_name: 'Cooperatives::Office'
    has_many :account_sub_categories,  class_name: 'AccountingModule::AccountSubCategory', foreign_key: 'main_category_id'
    has_many :sub_categories,          through: :account_sub_categories, source: :sub_category
    has_many :accounts,                class_name: 'AccountingModule::Account', dependent: :nullify
    has_many :amounts,                 through: :accounts, class_name: 'AccountingModule::Amount'
    has_many :debit_amounts,           through: :accounts, class_name: 'AccountingModule::DebitAmount'
    has_many :credit_amounts,          through: :accounts, class_name: 'AccountingModule::CreditAmount'
    has_many :entries,                 through: :accounts, class_name: 'AccountingModule::Entry'
    has_many :debit_entries,           through: :accounts, class_name: 'AccountingModule::Entry'
    has_many :credit_entries,          through: :accounts, class_name: 'AccountingModule::Entry'

    validates :title, :code, presence: true, uniqueness: { scope: :cooperative_id }
    validates :type, presence: true
    delegate :name, to: :cooperative, prefix: true

    scope :assets,      -> { where(type: 'AccountingModule::AccountCategories::Asset') }
    scope :liabilities, -> { where(type: 'AccountingModule::AccountCategories::Liability') }
    scope :equities,    -> { where(type: 'AccountingModule::AccountCategories::Equity') }
    scope :revenues,    -> { where(type: 'AccountingModule::AccountCategories::Revenue') }
    scope :expenses,    -> { where(type: 'AccountingModule::AccountCategories::Expense') }


    def self.types
      ["AccountingModule::AccountCategories::Asset",
       "AccountingModule::AccountCategories::Equity",
       "AccountingModule::AccountCategories::Liability",
       "AccountingModule::AccountCategories::Expense",
       "AccountingModule::AccountCategories::Revenue"]
    end

    def self.main_categories
      ids = AccountingModule::AccountSubCategory.main_category_ids + self.ids
      where(id: ids.uniq.compact.flatten).
      where.not(id: AccountingModule::AccountSubCategory.sub_category_ids)
    end

    def self.without_sub_categories
      ids = AccountingModule::AccountSubCategory.sub_category_ids + self.ids
      where(id: ids.uniq.compact.flatten).
      where.not(id: AccountingModule::AccountSubCategory.main_category_ids)
    end


    def all_accounts
      account_ids = []
      account_ids << accounts.ids
      account_ids << sub_categories.map{|sub| sub.accounts.ids }
      AccountingModule::Account.where(id: account_ids.uniq.compact.flatten)
    end

    def self.balance(args={})
      accounts_balance = BigDecimal('0')
      without_sub_categories.each do |category|
        if category.contra?
          accounts_balance -= category.balance(args)
        else
          accounts_balance += category.balance(args)
        end
      end
      accounts_balance
    end


    def self.debits_balance(args={})
      accounts_balance = BigDecimal('0')
      without_sub_categories.each do |category|
        if category.contra?
          accounts_balance -= category.debits_balance(args)
        else
          accounts_balance += category.debits_balance(args)
        end
      end
      accounts_balance
    end

    def self.credits_balance(args={})
      accounts_balance = BigDecimal('0')
      self.all.each do |main_category|
        if main_category.sub_categories.exists?
          main_category.sub_categories.each do |category|
            if category.contra?
              accounts_balance -= category.credits_balance(args)
            else
              accounts_balance += category.credits_balance(args)
            end
          end
        end
      end
      accounts_balance
    end

    def balance(args={})
      return raise(NoMethodError, "undefined method 'balance'") if self.class == AccountingModule::AccountCategory
      if self.normal_credit_balance ^ contra
        credits_balance(args) - debits_balance(args)
      else
        debits_balance(args) - credits_balance(args)
      end
    end

    def credits_balance(args={})
      accounts_balance = BigDecimal('0')
      if sub_categories.exists?
        sub_categories.each do |category|
          accounts_balance += category.credits_balance(args)
        end
      else
        accounts_balance += credit_amounts.balance(args)
      end
      accounts_balance
    end

    def debits_balance(args={})
      accounts_balance = BigDecimal('0')
      if sub_categories.exists?
        sub_categories.each do |category|
          accounts_balance += category.debits_balance(args)
        end
      else
        accounts_balance += debit_amounts.balance(args)
      end
      accounts_balance
    end

    def normalized_type
      type.gsub("AccountingModule::AccountCategories::", "")
    end
  end
end
