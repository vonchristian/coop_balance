module AccountingModule
  class Amount < ApplicationRecord
    extend AccountingModule::BalanceFinder
    belongs_to :entry, :class_name => 'AccountingModule::Entry', touch: true
    belongs_to :account, :class_name => 'AccountingModule::Account', touch: true
    belongs_to :recorder, class_name: "User", foreign_key: 'recorder_id', touch: true
    belongs_to :commercial_document, polymorphic: true, touch: true
    belongs_to :cooperative_service, class_name: "CoopServicesModule::CooperativeService"

    validates :type, :amount, :entry, :account, :commercial_document_id,  presence: true
    validates :amount, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :recorder, :reference_number, :description,  to: :entry
    delegate :name, to: :recorder, prefix: true
    before_save :set_default_date

    def self.for(account)
      where(account: account)
    end

    def self.recorded_by(recorder_id)
      where(recorder_id: recorder_id)
    end

    def self.entries_for(options={})
      where(commercial_document: options[:commercial_document])
    end

    def self.entered_on(options={})
      from_date = options[:from_date]
      to_date = options[:to_date]
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      where('entry_date' => date_range.range)
    end

    private
    def set_default_date
      self.entry_date = self.entry.entry_date
    end
  end
end
