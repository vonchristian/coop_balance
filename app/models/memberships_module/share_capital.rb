module MembershipsModule
  class ShareCapital < ApplicationRecord
    include PgSearch 
    pg_search_scope :text_search, :against => [:account_number]
    
    belongs_to :account_owner, class_name: "Member", foreign_key: 'member_id'
    belongs_to :share_capital_product, class_name: "CoopServicesModule::ShareCapitalProduct"
    has_many :capital_build_ups, class_name: "AccountingModule::Entry", as: :commercial_document
    
    delegate :name, to: :share_capital_product, allow_nil: true
    delegate :cost_per_share, to: :share_capital_product, allow_nil: true

    def self.subscribed_shares
      all.sum(&:subscribed_shares)
    end
    def subscribed_shares
      (capital_build_ups.total / share_capital_product.cost_per_share.to_i)
    end
    def balance
      capital_build_ups.capital_build_up.map{|a| a.debit_amounts.sum(:amount) }.sum
    end
  end
end