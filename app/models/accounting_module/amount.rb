module AccountingModule
  class Amount < ApplicationRecord
    extend AccountingModule::BalanceFinder
    belongs_to :entry, :class_name => 'AccountingModule::Entry', touch: true
    belongs_to :account, :class_name => 'AccountingModule::Account', touch: true
    belongs_to :commercial_document, polymorphic: true, touch: true

    validates :type, :amount, :entry, :account, :commercial_document_id, :commercial_document_type,  presence: true
    validates :amount, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :recorder, :reference_number, :description, :entry_date,  to: :entry
    delegate :name, to: :recorder, prefix: true

    def self.for_account(args={})
      where(account_id: args[:account_id])
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
  end
end
