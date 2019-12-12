module MembershipsModule
  class ShareCapital < ApplicationRecord
    include PgSearch::Model
    include InactivityMonitoring
    extend  PercentActive

    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :cooperative
    belongs_to :subscriber,                   polymorphic: true, touch: true
    belongs_to :share_capital_product,        class_name: "CoopServicesModule::ShareCapitalProduct"
    belongs_to :office,                       class_name: "Cooperatives::Office"
    belongs_to :barangay,                     class_name: "Addresses::Barangay", optional: true
    belongs_to :organization,                 optional: true
    belongs_to :share_capital_equity_account, class_name: 'AccountingModule::Account', foreign_key: 'equity_account_id'
    belongs_to :interest_on_capital_account,  class_name: 'AccountingModule::Account', foreign_key: 'interest_on_capital_account_id'
    has_many   :entries,                      class_name: 'AccountingModule::Entry', through: :share_capital_equity_account
    delegate :name, to: :barangay, prefix: true, allow_nil: true
    delegate :name,
            :equity_account,
            :transfer_fee_account,
            :transfer_fee,
            :default_product?,
            :interest_payable_account,
            :cost_per_share,
             to: :share_capital_product, prefix: true
    delegate :name, :current_address_complete_address, :current_contact_number, to: :subscriber, prefix: true
    delegate :avatar, :name, to: :subscriber
    delegate :name, to: :office, prefix: true
    delegate :balance, to: :share_capital_equity_account

    before_save :set_account_owner_name
    def self.equity_accounts
      ids = pluck(:equity_account_id)
      AccountingModule::Account.where(id: ids)
    end 

    def self.total_balances(args={})
      equity_accounts.balance(args)
    end

    def self.inactive(options={})
      updated_at(options)
    end

    def self.updated_at(options={})
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


    def capital_build_ups(args={})
      entries
    end


    def average_monthly_balance(args = {})
      first_entry_date = Date.today - 999.years
      date = args[:date]
      balance(from_date: first_entry_date, to_date: date.beginning_of_month.last_month.end_of_month) +
      capital_build_ups(from_date: date.beginning_of_month, to_date: (date.beginning_of_month + 14.days)).sum(&:amount)
    end

    def averaged_monthly_balances
      months = []
      (DateTime.now.beginning_of_year..DateTime.now.end_of_year).each do |month|
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

    def computed_interest(args={})
      net_income_distributable = args[:net_income_distributable]
      averaged_monthly_balances / net_income_distributable
    end

    private
    def set_account_owner_name
      self.account_owner_name = self.subscriber_name
    end
  end
end
