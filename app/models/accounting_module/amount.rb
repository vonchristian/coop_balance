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

    def debit?
      type == "AccountingModule::DebitAmount"
    end

    def credit?
      type == "AccountingModule::CreditAmount"
    end

    def self.recorded_by(recorder_id)
      where('recorder_id' => recorder_id)
    end
    def self.entered_on(hash={})
      if hash[:from_date] && hash[:to_date]
        date_range = DateRange.new(from_date: hash[:from_date], to_date: hash[:to_date])
        where('created_at' => (date_range.start_date)..(date_range.end_date))
      else
        all
      end
    end

  end
end
