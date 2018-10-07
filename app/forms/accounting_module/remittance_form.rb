module AccountingModule
  class RemittanceForm
    include ActiveModel::Model
    attr_accessor :recorder_id, :user_id, :amount,  :entry_date, :description, :reference_number, :remitted_to_id

    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, :remitted_to_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_remittance
      end
    end

    def save_remittance
      AccountingModule::Entry.create!(
        recorder: find_recorder,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        commercial_document: find_remitted_to,  description: description, reference_number: reference_number, entry_date: entry_date,
      debit_amounts_attributes: [account_id: debit_account_id, amount: amount, commercial_document: find_recorder],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount, commercial_document: find_recorder])
    end
    def find_recorder
      User.find_by_id(recorder_id)
    end
    def find_remitted_to
      User.find_by_id(remitted_to_id)
    end
    def debit_account_id
      find_remitted_to.cash_on_hand_account_id
    end
    def credit_account_id
      find_recorder.cash_on_hand_account_id
    end
  end
end
