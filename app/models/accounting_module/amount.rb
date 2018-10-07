module AccountingModule
  class Amount < ApplicationRecord
    extend AccountingModule::BalanceFinder
    belongs_to :entry, :class_name => 'AccountingModule::Entry', touch: true
    belongs_to :account, :class_name => 'AccountingModule::Account', touch: true
    belongs_to :commercial_document, polymorphic: true, touch: true

    validates :type, :amount, :entry, :account, :commercial_document_id, :commercial_document_type,  presence: true
    validates :amount, numericality: { greater_than: 0.01 }

    delegate :name, to: :account, prefix: true
    delegate :recorder, :reference_number, :description, :entry_date,  to: :entry
    delegate :name, to: :recorder, prefix: true

    def self.for_account(args={})
      where(account: args[:account])
    end

    def self.recorded_by(recorder_id)
      where(recorder_id: recorder_id)
    end

    def self.entries_for_commercial_document(options={})
      where(commercial_document: options[:commercial_document])
    end

    def self.entered_on(options={})
      from_date = options[:from_date]
      to_date = options[:to_date]
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      includes(:entry).where('entries.entry_date' => date_range.range)
    end

    def debit?
      type == "AccountingModule::DebitAmount"
    end
    def credit?
      type == "AccountingModule::CreditAmount"
    end
  end
end
