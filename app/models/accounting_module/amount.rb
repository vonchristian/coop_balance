module AccountingModule
  class Amount < ApplicationRecord
    audited
    monetize :amount_cents, as: :amount, numericality: {
              greater_than_or_equal_to: 0
            }
    extend AccountingModule::BalanceFinder
    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account'
    belongs_to :commercial_document, polymorphic: true, optional: true

    validates :type, :amount, :entry, :account,  presence: true
    validates :amount, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :recorder, :reference_number, :description, :entry_date,  to: :entry
    delegate :name, to: :recorder, prefix: true

    def self.for_account(args={})
      where(account_id: args[:account_id])
    end

    def self.excluding_account(args={})
      where.not(account: args[:account])
    end

    def self.total_cash_amount
      where(account: Employees::EmployeeCashAccount.cash_accounts).total
    end

    def self.for_recorder(args={})
      joins(:entry).where('entries.recorder_id' => args[:recorder_id])
    end

    def self.for_commercial_document(args={})
      where(commercial_document: args[:commercial_document])
    end

    def self.entered_on(args={})
      from_date = args[:from_date] || Date.today - 999.years
      to_date = args[:to_date] || Date.today
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      includes(:entry).where('entries.cancelled' => false).where('entries.entry_date' => date_range.start_date..date_range.end_date)
    end

    def debit?
      type == "AccountingModule::DebitAmount"
    end

    def credit?
      type == "AccountingModule::CreditAmount"
    end
    def self.total
      all.map{ |a| a.amount.amount }.sum
    end
  end
end
