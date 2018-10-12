module MembershipsModule
  class ShareCapital < ApplicationRecord
    include PgSearch
    include InactivityMonitoring
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :cooperative
    belongs_to :subscriber, polymorphic: true, touch: true
    belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    belongs_to :barangay, class_name: "Addresses::Barangay", optional: true
    belongs_to :organization, optional: true
    has_many :amounts, as: :commercial_document, class_name: "AccountingModule::Amount"
    delegate :name, to: :barangay, prefix: true, allow_nil: true
    delegate :name,
            :paid_up_account,
            :subscription_account,
            :closing_account_fee,
            :default_paid_up_account,
            :default_product?,
            :cost_per_share,
            :default_subscription_account, to: :share_capital_product, prefix: true
    delegate :name, to: :office, prefix: true
    delegate :name, to: :subscriber, prefix: true
    delegate :avatar, to: :subscriber
    before_save :set_account_owner_name, on: [:create, :update]

    def self.inactive(options={})
      updated_at(options)
    end

    def self.updated_at(options={})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        where('updated_at' => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.has_minimum_balance
      self.where(has_minimum_balance: true)
    end

    def self.below_minimum_balance
      self.where(has_minimum_balance: false)
    end

    def self.default
      select {|a| a.share_capital_product_default_product? }
    end

    def capital_build_ups(args={})
      share_capital_product_paid_up_account.amounts.where(commercial_document: self) +
      share_capital_product_paid_up_account.amounts.where(commercial_document: self.subscriber)
    end

    def self.balance
      sum(&:balance)
    end

    def average_monthly_balance(args = {})
      first_entry_date = AccountingModule::Entry.order(entry_date: :desc).last.try(:entry_date) || Date.today
      date = args[:date]
      paid_up_balance(from_date: first_entry_date, to_date: date.beginning_of_month.last_month.end_of_month, commercial_document: self) +
      capital_build_ups(commercial_document: self, from_date: date.beginning_of_month, to_date: (date.beginning_of_month + 14.days)).sum(&:amount)
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

    def entries
      accounting_entries = []
      share_capital_product_paid_up_account.amounts.includes(:entry => [:credit_amounts]).where(commercial_document: self).each do |amount|
        accounting_entries << amount.entry
      end

      accounting_entries.uniq
    end

    def self.subscribed_shares
      all.sum(&:subscribed_shares)
    end

    def paid_up_shares
      paid_up_balance / share_capital_product_cost_per_share
    end

    def paid_up_balance(args={})
      share_capital_product_default_paid_up_account.balance(from_date: args[:from_date], to_date: args[:to_date], commercial_document: self) +
      share_capital_product_default_paid_up_account.balance(from_date: args[:from_date], to_date: args[:to_date], commercial_document: self.subscriber)
    end

    def subscription_balance
      share_capital_product_subscription_account.balance(commercial_document: self)
    end

    def dividends_earned
      share_capital_product_interest_payable_account.balance(commercial_document: self)
    end
    def dividends_total
      # entries.share_capital_dividend.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum
    end
    def name
      account_owner_name || subscriber_name
    end

    def set_balance_status
      if paid_up_balance >= share_capital_product.minimum_balance
        self.has_minimum_balance = true
      else
        self.has_minimum_balance = false
      end
      self.save
    end



    private

    def set_account_owner_name
      self.account_owner_name = self.subscriber_name
    end
  end
end
