module MembershipsModule
  class TimeDeposit < ApplicationRecord
    enum status: [:withdrawn]
    include TermMonitoring
    include PgSearch
    pg_search_scope :text_search, against: [:account_number, :depositor_name]

    belongs_to :cooperative
    belongs_to :depositor,            polymorphic: true, touch: true
    belongs_to :office,               class_name: "CoopConfigurationsModule::Office"
    belongs_to :time_deposit_product, class_name: "CoopServicesModule::TimeDepositProduct"
    belongs_to :organization,         optional: true
    belongs_to :barangay,             optional: true, class_name: "Addresses::Barangay"

    delegate :name, :interest_rate, :account, :interest_expense_account, :break_contract_fee, to: :time_deposit_product, prefix: true
    delegate :full_name, :first_and_last_name, to: :depositor, prefix: true
    delegate :name, to: :office, prefix: true
    delegate :name, to: :depositor
    delegate :avatar, to: :depositor

    before_save :set_depositor_name, on: [:create]

    def entries
      accounting_entries = []
      time_deposit_product_account.amounts.where(commercial_document: self).each do |amount|
        accounting_entries << amount.entry
      end
      accounting_entries
    end

    def can_be_extended?
      !withdrawn? && current_term_matured?
    end

    def withdrawal_date
      if withdrawn?
        entries.sort_by(&:entry_date).reverse.first.entry_date
      end
    end

    def member?
      depositor.regular_member?
    end

    def non_member?
      !depositor.regular_member?
    end

    def self.matured
      all.select{|a| a.current_term_matured? }
    end

    def self.post_interests_earned
      !current_term_matured.each do |time_deposit|
        post_interests_earned
      end
    end

    def post_interests_earned
      TimeDepositsModule::InterestEarnedPosting.post_for(self)
    end


    def amount_deposited
      balance
    end
    def disbursed?
      true
    end

    def balance
      time_deposit_product_account.balance(commercial_document: self)
    end

    def earned_interests
      CoopConfigurationsModule::TimeDepositConfig.earned_interests_for(self)
    end
    def computed_break_contract_amount
      time_deposit_product.break_contract_rate * amount_deposited
    end
    def computed_earned_interests
      if current_term_matured?
        amount_deposited * rate
      else
        amount_deposited *
        rate *
        days_elapsed
      end
    end

    def days_elapsed
       (Time.zone.now - date_deposited) /86400
    end

    def rate
      time_deposit_product.monthly_interest_rate * current_term.number_of_months
    end

    private
    def set_depositor_name
      self.depositor_name ||= self.depositor_full_name
    end
  end
end
