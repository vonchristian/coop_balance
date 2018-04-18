module AccountingModule
  class Amount < ApplicationRecord
    extend AccountingModule::BalanceFinder
    belongs_to :entry, :class_name => 'AccountingModule::Entry', touch: true
    belongs_to :account, :class_name => 'AccountingModule::Account', touch: true
    belongs_to :recorder, class_name: "User", foreign_key: 'recorder_id', touch: true
    belongs_to :commercial_document, polymorphic: true, touch: true

    validates :type, :amount, :entry, :account, :commercial_document_id,  presence: true
    validates :amount, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :entry_date, :recorder, :reference_number, :description,  to: :entry
    def self.for(account)
      where(account: account)
    end
    def self.recorded_by(recorder_id)
      where(recorder_id: recorder_id)
    end

    def self.entered_on(options={})
      first_entry_date = AccountingModule::Entry.order(entry_date: :desc).last.try(:entry_date) || Date.today
      from_date = options[:from_date] || first_entry_date
      to_date = options[:to_date] || Date.today
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      joins(:entry, :account).
      where('entries.entry_date' => date_range.start_date..date_range.end_date)
    end
  end
end
