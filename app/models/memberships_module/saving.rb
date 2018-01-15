module MembershipsModule
  class Saving < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]
    belongs_to :depositor, polymorphic: true
    belongs_to :saving_product, class_name: "CoopServicesModule::SavingProduct"
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    delegate :name, :current_occupation, to: :depositor, prefix: true
    delegate :name,
             :account,
             :closing_account,
             :interest_rate,
             :interest_expense_account, to: :saving_product, prefix: true
    delegate :name, to: :office, prefix: true, allow_nil: true
    has_many :entries, class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    before_save :set_account_owner_name, :set_account_number
    validates :saving_product_id, presence: true

    def closed?
      saving_product_closing_account.entries.where(commercial_document: self).present?
    end
    def interest_posted?(date)
     saving_product_interest_expense_account.credit_entries.entered_on(from_date: saving_product.beginning_date_for(date), to_date: saving_product.ending_date_for(date)).present?
    end

    def self.generate_account_number
      if self.exists? && order(created_at: :asc).last.account_number.present?
        order(created_at: :asc).last.account_number.succ
      else
        "#{Time.zone.now.year.to_s.last(2)}000001"
      end
    end

    def self.with_minimum_balances
      all.select{|a| a.balance >= saving_product.minimum_balance }
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

    def de
      posits
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
