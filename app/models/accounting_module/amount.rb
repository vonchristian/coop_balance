module AccountingModule
  class Amount < ApplicationRecord
    belongs_to :entry, :class_name => 'AccountingDepartment::Entry'
    belongs_to :account, :class_name => 'AccountingDepartment::Account'

    validates :type, :amount, :entry, :account, presence: true
    validates :amount, numericality: { greater_than: 0.1 }

  end
end
