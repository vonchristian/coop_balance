#use to consolidate accounts into a single category
module AccountingModule
  class AccountCategory < ApplicationRecord
    extend AccountingModule::UpdatedAtFinder
    enum category_type: [:asset, :liability, :equity, :revenue, :expense]
    belongs_to :cooperative
    has_many :account_sub_categories,  class_name: 'AccountingModule::AccountSubCategory', foreign_key: 'main_category_id'
    has_many :sub_categories,          through: :account_sub_categories, source: :sub_category
    has_many :accounts,                class_name: 'AccountingModule::Account', dependent: :nullify
    has_many :entries,                 through: :accounts
    has_many :debit_entries,                 through: :accounts
    has_many :credit_entries,                 through: :accounts


    validates :title, :code, presence: true, uniqueness: { scope: :cooperative_id }
    validates :category_type, presence: true
    delegate :name, to: :cooperative, prefix: true


    def self.without_sub_categories
      where.not(id: AccountingModule::AccountSubCategory.main_categories.ids)
    end

    def all_accounts
      account_ids = []
      account_ids << accounts.ids
      account_ids << sub_categories.map{|sub| sub.accounts.ids }
      AccountingModule::Account.where(id: account_ids.uniq.compact.flatten)
    end

    def self.main_categories
      where(id: AccountingModule::AccountSubCategory.main_categories.ids).
      where.not(id: AccountingModule::AccountSubCategory.sub_categories.ids)
    end

    def self.balance(args={})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        accounts_balance += category.balance(args)
      end
      accounts_balance
    end

    def self.debits_balance(args={})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        accounts_balance += category.debits_balance(args)
      end
      accounts_balance
    end

    def self.credits_balance(args={})
      accounts_balance = BigDecimal('0')
      self.all.each do |category|
        accounts_balance += category.credits_balance(args)
      end
      accounts_balance
    end

    def balance(args={})
      accounts_balance ||= BigDecimal('0')
      if sub_categories.exists?
        sub_categories.balance(args)
      else
        accounts.includes(:amounts => :entry).each do |account|
          accounts_balance += account.balance(args)
        end
        accounts_balance
      end
    end

    def debits_balance(args={})
      if sub_categories.exists?
        sub_categories.debits_balance(args)
      else
        accounts_balance = BigDecimal('0')
        accounts.includes(:debit_amounts =>:entry).each do |account|
          accounts_balance += account.debits_balance(args)
        end
        accounts_balance
      end
    end

    def credits_balance(args={})
      if sub_categories.exists?
        sub_categories.credits_balance(args)
      else
        accounts_balance = BigDecimal('0')
        accounts.includes(:debit_amounts =>:entry).each do |account|
          accounts_balance += account.credits_balance(args)
        end
        accounts_balance
      end
    end
  end
end
