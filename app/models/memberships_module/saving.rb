module MembershipsModule
  class Saving < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :depositor,        polymorphic: true,  touch: true
    belongs_to :saving_product,   class_name: "CoopServicesModule::SavingProduct"
    belongs_to :office,           class_name: "CoopConfigurationsModule::Office"
    has_many   :entries,         class_name: "AccountingModule::Entry",
                                  as: :commercial_document
    delegate :name, :current_occupation, to: :depositor, prefix: true
    delegate :name,
             :account,
             :closing_account,
             :interest_rate,
             :interest_expense_account, to: :saving_product, prefix: true
    delegate :name, to: :office, prefix: true, allow_nil: true
    delegate :name, to: :depositor, prefix: true

    scope :has_minimum_balance, -> { SavingsQuery.new.has_minimum_balance  }
    before_save :set_account_owner_name
    def entries
      accounting_entries = []
      saving_product_account.amounts.where(commercial_document: self).each do |amount|
        accounting_entries << amount.entry
      end
      accounting_entries
    end
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
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        where('updated_at' => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.top_savers(limiting_num=10)
      all.to_a.sort_by(&:balance).first(limiting_num)
    end

    def name
      depositor_name
    end
    def post_interests_earned(date)
      InterestPosting.new.post_interests_earned(self, date)
    end

    def balance(options={})
      saving_product_account.balance(commercial_document_id: self.id, commercial_document_type: self.class.to_s)
    end

    def deposits
      saving_product_account.credits_balance(commercial_document_id: self.id, commercial_document_type: self.class.to_s)
    end
    def withdrawals
      saving_product_account.debits_balance(commercial_document_id: self.id, commercial_document_type: self.class.to_s)
    end
    def interests_earned
      saving_product_interest_expense_account.credits_balance(commercial_document_id: self.id, commercial_document_type: self.class.to_s)
    end
    def can_withdraw?
      !closed? && balance > 0.0
    end
    def first_transaction_date
      if entries.any?
        entries.sort_by(&:entry_date).first.entry_date
      end
    end
    def last_transaction_date
      if entries.any?
        entries.sort_by(&:entry_date).reverse.first.entry_date.strftime("%B %e, %Y")
      else
        "No Transactions"
      end
    end
    def average_daily_balance
      balances = []
      (Date.today.beginning_of_quarter..Date.today.end_of_quarter).each do |date|
        daily_balance = saving_product.balance(commercial_document_id: self.id, commercial_document_type: self.class.to_s, from_date: self.first_transaction_date, to_date: date.end_of_day)
        balances << daily_balance
      end
      balances.sum / balances.size
    end
    private
    def set_account_owner_name
      self.account_owner_name = self.depositor_name
    end
  end
end
