module MembershipsModule
  class ShareCapital < ApplicationRecord
    include PgSearch 
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]
    
    belongs_to :subscriber, polymorphic: true
    belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    
    delegate :name, to: :share_capital_product, prefix: true
    delegate :name, to: :subscriber, prefix: true
    delegate :cost_per_share, to: :share_capital_product, prefix: true

    after_commit :set_account_owner_name    
    def self.subscribed_shares
      all.sum(&:subscribed_shares)
    end

    def subscribed_shares
      (capital_build_ups_total / share_capital_product_cost_per_share.to_i)
    end

    def balance
      capital_build_ups_total
    end

    def capital_build_ups_total
      share_capital_product.credit_account.balance(commercial_document_id: self.id)
    end
    def dividends
    end
    def dividends_total
      entries.share_capital_dividend.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum
    end
    private 
    def set_account_owner_name
      self.account_owner_name = self.subscriber_name
    end
    
    def name 
      account_owner_name || subscriber_name
    end
  end
end