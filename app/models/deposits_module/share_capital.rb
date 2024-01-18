module DepositsModule
  class ShareCapital < ApplicationRecord
    include PgSearch::Model
    include InactivityMonitoring
    extend  PercentActive

    pg_search_scope :text_search, against: %i[account_number account_owner_name]
    pg_search_scope :account_number_search, against: [:account_number]

    multisearchable against: %i[account_number account_owner_name]

    belongs_to :office, class_name: 'Cooperatives::Office'
    belongs_to :cooperative
    belongs_to :subscriber,                   polymorphic: true
    belongs_to :share_capital_product,        class_name: 'CoopServicesModule::ShareCapitalProduct'
    belongs_to :barangay,                     class_name: 'Addresses::Barangay', optional: true
    belongs_to :organization,                 optional: true
    belongs_to :share_capital_equity_account, class_name: 'AccountingModule::Account', foreign_key: 'equity_account_id'
    has_many   :accountable_accounts,         class_name: 'AccountingModule::AccountableAccount', as: :accountable
    has_many   :accounts,                     through: :accountable_accounts, class_name: 'AccountingModule::Account'
    has_many   :amounts,                      through: :accounts, class_name: 'AccountingModule::Amount'
    has_many   :debit_amounts,                through: :accounts, class_name: 'AccountingModule::DebitAmount'
    has_many   :credit_amounts, through: :accounts, class_name: 'AccountingModule::CreditAmount'

    delegate :name, to: :barangay, prefix: true, allow_nil: true
    delegate :name,
             :equity_account,
             :default_product?,
             :cost_per_share,
             to: :share_capital_product, prefix: true
    delegate :name, :current_address_complete_address, :current_contact_number, to: :subscriber, prefix: true
    delegate :avatar, :name, to: :subscriber
    delegate :name, to: :office, prefix: true
    delegate :balance, :debits_balance, :credits_balance, to: :share_capital_equity_account

    delegate :name, to: :share_capital_equity_account, prefix: true

    before_save :set_account_owner_name
    def self.withdrawn
      where.not(withdrawn_at: nil)
    end

    def self.equity_accounts
      ids = pluck(:equity_account_id)
      AccountingModule::Account.where(id: ids)
    end

    def self.interest_on_capital_accounts
      ids = pluck(:interest_on_capital_account_id)
      AccountingModule::Account.where(id: ids)
    end

    def self.total_balances(args = {})
      equity_accounts.balance(args)
    end

    def self.inactive(options = {})
      updated_at(options)
    end

    def self.updated_at(options = {})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        joins(:entries).where('entries.entry_date' => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.has_minimum_balance
      where(has_minimum_balance: true)
    end

    def self.below_minimum_balance
      where(has_minimum_balance: false)
    end

    delegate :entries, to: :share_capital_equity_account

    def capital_build_ups(_args = {})
      entries
    end

    def average_monthly_balance(args = {})
      first_entry_date = Time.zone.today - 999.years
      date = args[:date]
      balance(from_date: first_entry_date, to_date: date.beginning_of_month.last_month.end_of_month) +
        capital_build_ups(from_date: date.beginning_of_month, to_date: (date.beginning_of_month + 14.days)).sum(&:amount)
    end

    def averaged_monthly_balances
      months = []
      DateTime.now.all_year.each do |month|
        months << month.beginning_of_month
      end
      balances = []
      months.uniq.each do |month|
        balances << average_monthly_balance(date: month.beginning_of_month)
      end
      balances.sum / balances.size
    end

    def self.subscribed_shares
      all.sum(&:shares)
    end

    def shares
      balance / share_capital_product_cost_per_share
    end

    def dividends_earned(args = {})
      interest_on_capital_account.balance(args)
    end

    def name
      account_owner_name || subscriber_name
    end

    def account_name
      name
    end

    def computed_interest(args = {})
      net_income_distributable = args[:net_income_distributable]
      averaged_monthly_balances / net_income_distributable
    end

    def last_transaction_date
      return created_at if entries.with_cash_accounts.blank?

      entries.with_cash_accounts.recent.entry_date
    end

    private

    def set_account_owner_name
      self.account_owner_name ||= subscriber_name
    end
  end
end
