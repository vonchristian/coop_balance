module MembershipsModule
  class ShareCapital < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]
    belongs_to :subscriber, polymorphic: true
    belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    delegate :name,
            :paid_up_account,
            :subscription_account,
            :closing_account,
            :interest_payable_account,
            :closing_account_fee,
            :default_paid_up_account,
            :default_product?,
            :default_subscription_account, to: :share_capital_product, prefix: true
    delegate :name, to: :office, prefix: true
    delegate :name, to: :subscriber, prefix: true
    delegate :avatar, to: :subscriber
    before_save :set_account_owner_name
    def self.default
      select{|a| a.share_capital_product_default_product? }
    end

    def capital_build_ups
      share_capital_product_paid_up_account.credit_amounts.where(commercial_document: self) +
      share_capital_product_paid_up_account.credit_amounts.where(commercial_document: self.subscriber)
    end
    def self.balance
      sum(&:balance)
    end

    def average_balance
      balances = []
      balance(from_date: (Time.zone.now.last_year.end_of_year - 15.days), to_date: Time.zone.now.last_year.end_of_year + 15.days) #january
      balance(from_date: Time.zone.now.beginning_of_year, to_date: (Time.zone.now.beginning_of_year + 14.days)) #february
      balance(from_date: Time.zone.now.beginning_of_year.next_month, to_date: (Time.zone.now.beginning_of_year.next_month + 14.days))
      balance(from_date: Time.zone.now.beginning_of_year.next_month, to_date: (Time.zone.now.beginning_of_year.next_month + 14.days))
      balances.sum / balances.length
    end
    def closed?
      share_capital_product_closing_account.entries.where(commercial_document: self).present? ||
      share_capital_product_closing_account.entries.where(commercial_document: self.subscriber).present?
    end

    def entries
      share_capital_product_paid_up_account.entries.where(commercial_document: self) +
      share_capital_product_closing_account.entries.where(commercial_document: self)
    end

    def self.subscribed_shares
      all.sum(&:subscribed_shares)
    end

    def subscribed_shares
      share_capital_product_default_subscription_account.balance(commercial_document_d: self.id)
    end

    def balance
      share_capital_product_default_paid_up_account.balance(commercial_document_id: self.id) +
      share_capital_product_default_paid_up_account.balance(commercial_document_id: self.subscriber_id)
    end

    def dividends_earned
      share_capital_product_interest_payable_account.balance(commercial_document_id: self.id)
    end
    def dividends_total
      # entries.share_capital_dividend.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum
    end
    def name
      account_owner_name || subscriber_name
    end

    private
    def set_account_owner_name
      self.account_owner_name = self.subscriber_name
    end
  end
end
