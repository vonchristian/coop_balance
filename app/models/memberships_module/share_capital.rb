module MembershipsModule
  class ShareCapital < ApplicationRecord
    include PgSearch 
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]
    belongs_to :account_owner, class_name: "Member", foreign_key: 'member_id'
    belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document
    
    delegate :name, to: :share_capital_product, allow_nil: true, prefix: true
    delegate :cost_per_share, to: :share_capital_product, allow_nil: true
    after_commit :set_account_owner_name, :set_account_number
    def self.subscribed_shares
      all.sum(&:subscribed_shares)
    end
    def subscribed_shares
      (capital_build_ups.total / share_capital_product.cost_per_share.to_i)
    end
    def balance
      capital_build_ups_total
    end
    def capital_build_ups_total
      entries.capital_build_up.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum
    end
    def dividends
    end
    def dividends_total
      entries.share_capital_dividend.map{|a| a.debit_amounts.distinct.sum(:amount) }.sum
    end
    private 
    def set_account_owner_name
      self.account_owner_name = self.account_owner.full_name
    end
    def set_account_number 
      self.account_number = self.id 
    end
    def name 
      account_owner_name || account_owner.full_name
    end
  end
end