module MembershipsModule
  class Saving < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :depositor, polymorphic: true
    belongs_to :saving_product, class_name: "CoopServicesModule::SavingProduct"
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy

    delegate :name, :current_occupation, to: :depositor, prefix: true
    delegate :name,
             :account,
             :closing_account,
             :interest_rate,
             :interest_expense_account, to: :saving_product, prefix: true
    delegate :name, to: :office, prefix: true, allow_nil: true

    before_save :set_account_owner_name, :set_account_number

    validates :saving_product_id, presence: true
  scope :has_minimum_balance, -> { SavingsQuery.new.has_minimum_balance  }

    def closed?
      saving_product_closing_account.amounts.where(commercial_document: self).present?
    end

    def number_of_days_inactive
      (Time.zone.now - updated_at)/86_400.0
    end

    def interest_posted?(date)
      saving_product.interest_posted?(date)
    end



    def self.set_inactive_accounts
      #to do find accounts not within saving product interest posting date range
      # did not save for a set time
    end

    def self.updated_at(options={})
      if options[:from_date] && options[:to_date]
        from_date = Chronic.parse(options[:from_date].to_date)
        to_date = Chronic.parse(options[:to_date].to_date)
        where('updated_at' => (from_date.beginning_of_day)..(to_date.end_of_day))
      else
        all
      end
    end

    def self.top_savers
      all.to_a.sort_by(&:balance).first(10)
    end

    def name
      account_owner_name || account_owner.full_name
    end
    def post_interests_earned(date)
      InterestPosting.new.post_interests_earned(self, date)
    end

    def balance
      saving_product_account.balance(commercial_document_id: self.id)
    end

    def deposits
      saving_product_account.credits_balance(commercial_document_id: self.id)
    end
    def withdrawals
      saving_product_account.debits_balance(commercial_document_id: self.id)
    end
    def interests_earned
      saving_product_interest_expense_account.credits_balance(commercial_document_id: self.id)

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
  end
end
