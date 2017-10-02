module MembershipsModule
  class Saving < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]

    belongs_to :member, class_name: "Member", foreign_key: 'member_id'
    belongs_to :saving_product, class_name: "CoopServicesModule::SavingProduct"
    delegate :name, to: :saving_product, prefix: true, allow_nil: true
    delegate :interest_rate, to: :saving_product, prefix: true
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document
    before_save :set_account_owner_name
    def self.top_savers 
      all.to_a.sort_by(&:balance).first(10)
    end
    def self.post_interests_earned
      all.each do |saving|
        post_interests_earned(saving)
      end 
    end
    def post_interests_earned
      InterestPosting.new.post_interests_earned(self)
    end

    def balance
      deposits + interests_earned - withdrawals
    end
    def deposits
      entries.deposit.map{|a| a.debit_amounts.sum(:amount)}.sum
    end
    def withdrawals
      entries.withdrawal.map{|a| a.debit_amounts.sum(:amount)}.sum
    end
    def interests_earned
      entries.savings_interest.map{|a| a.debit_amounts.sum(:amount)}.sum
    end
    def can_withdraw?
      balance > 0.0
    end
    private 
    #used for pg search
    def set_account_owner_name
      self.account_owner_name = self.member.full_name
    end
  end
end