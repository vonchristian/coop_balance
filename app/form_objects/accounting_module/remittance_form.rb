module AccountingModule 
  class RemittanceForm
    include ActiveModel::Model
    attr_accessor :recorder_id, :user_id, :amount, :debit_account_id, :credit_account_id, :entry_type, :entry_date, :description, :reference_number, :commercial_document_id
 
    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, :debit_account_id, :credit_account_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_remittance
      end
    end
    
    def save_remittance
      AccountingModule::Entry.create!(recorder_id: recorder_id, commercial_document_id: commercial_document_id, commercial_document_type: "User", entry_type: entry_type,  description: description, reference_number: reference_number, entry_date: entry_date,
      debit_amounts_attributes: [account_id: debit_account_id, amount: amount],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount])
    end
  end 
end 