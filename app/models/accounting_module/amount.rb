module AccountingModule
  class Amount < ApplicationRecord
    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account', touch: 'entry.entry_date'

    validates :type, :amount, :entry, :account, presence: true
    validates :amount, numericality: true

  end
end
