module MembershipsModule
  class Saving < ApplicationRecord
    enum status: [:active, :inactive, :closed]
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]
    belongs_to :depositor, polymorphic: true
    belongs_to :saving_product, class_name: "CoopServicesModule::SavingProduct"
    delegate :name, :current_occupation, to: :depositor, prefix: true
    delegate :name, to: :saving_product, prefix: true, allow_nil: true
    delegate :interest_rate, to: :saving_product, prefix: true
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    before_save :set_account_owner_name, :set_account_number


    def self.top_savers
      all.to_a.sort_by(&:balance).first(10)
    end
    def self.post_interests_earned
      all.each do |saving|
        post_interests_earned(saving)
      end
    end
    def name
      account_owner_name || account_owner.full_name
    end
    def post_interests_earned
      InterestPosting.new.post_interests_earned(self)
    end

    def balance
      deposits + interests_earned - withdrawals
      #saving_product_account.balance(commercial_document: self)
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
      self.account_owner_name = self.depositor.name
    end
    def set_account_number
      self.account_number = self.id
    end
  end
end
