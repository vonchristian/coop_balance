module MembershipsModule
  class ShareCapital < ApplicationRecord
    enum status: [:active, :inactive, :closed]
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :subscriber, polymorphic: true
    belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"

    delegate :name, :paid_up_account, :subscription_account, :closing_account, :closing_account_fee, :default_paid_up_account, :default_subscription_account, to: :share_capital_product, prefix: true
    delegate :name, to: :office, prefix: true, allow_nil: true
    delegate :name, to: :subscriber, prefix: true
    delegate :cost_per_share, to: :share_capital_product, prefix: true
    validates :share_capital_product_id, presence: true
    after_commit :set_account_owner_name

    has_many :capital_build_ups, class_name: "AccountingModule::Entry", as: :commercial_document
    def closed?
      share_capital_product_closing_account.entries.where(commercial_document: self).present?
    end

    def entries
      share_capital_product_paid_up_account.entries.where(commercial_document_id: self)
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

    def capital_build_ups_total
      share_capital_product_default_paid_up_account.balance(commercial_document_id: self.id) +
      share_capital_product_default_paid_up_account.balance(commercial_document_id: self.subscriber_id)
    end
    def dividends
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
