module MembershipsModule
  class Saving < ApplicationRecord
    enum status: [:active, :inactive, :closed]
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]
    belongs_to :depositor, polymorphic: true
    belongs_to :saving_product, class_name: "CoopServicesModule::SavingProduct"
    belongs_to :branch_office, class_name: "CoopConfigurationsModule::BranchOffice"
    belongs_to :section, class_name: "CoopConfigurationsModule::Section"
    delegate :name, :current_occupation, to: :depositor, prefix: true
    delegate :name, :account, to: :saving_product, prefix: true
    delegate :interest_rate, to: :saving_product, prefix: true
    delegate :name, to: :branch_office, prefix: true, allow_nil: true
    delegate :name, to: :section, prefix: true, allow_nil: true
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    before_save :set_account_owner_name, :set_account_number
    def self.generate_account_number
      if self.exists? && order(created_at: :asc).last.account_number.present?
        order(created_at: :asc).last.account_number.succ
      else
        "#{Time.zone.now.year.to_s.last(2)}000001"
      end
    end

    def self.set_inactive_accounts
      #to do find accounts not within saving product interest posting date range
      # did not save for a set time
    end
    def self.top_savers
      all.to_a.sort_by(&:balance).first(10)
    end

    def name
      account_owner_name || account_owner.full_name
    end
    def post_interests_earned
      InterestPosting.new.post_interests_earned(self)
    end

    def balance
      # deposits + interests_earned - withdrawals
      saving_product_account.balance(commercial_document_id: self.id)
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
      !closed? && balance > 0.0
    end
    private
    #used for pg search
    def set_account_owner_name
      self.account_owner_name = self.depositor.name
    end
    def set_account_number
      self.account_number = self.id
    end

    def set_branch_office
      self.branch_office_id = self.depositor.branch_office.id
    end
  end
end
