module AccountingModule
  class Amount < ApplicationRecord
    belongs_to :entry, :class_name => 'AccountingModule::Entry'
    belongs_to :account, :class_name => 'AccountingModule::Account'
    belongs_to :recorder, class_name: "User", foreign_key: 'recorder_id'

    validates :type, :amount, :entry, :account, presence: true
    validates :amount, numericality: true

    def self.recorded_by(recorder_id)
      where('recorder_id' => recorder_id)
    end

  end
end
