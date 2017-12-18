module TreasuryModule
  class FundTransferForm
    include ActiveModel::Model
    attr_accessor :recorder_id,  :amount, :credit_account_id, :entry_type, :entry_date, :description, :reference_number, :commercial_document_id

    validates :amount,  presence: true, numericality: true
    validates :reference_number, :description, :credit_account_id, :commercial_document_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_fund_transfer
      end
    end
    def find_employee
      User.find_by(id: commercial_document_id)
    end

    def save_fund_transfer
      AccountingModule::Entry.create!(recorder_id: recorder_id, commercial_document_id: commercial_document_id, commercial_document_type: "User", description: description, reference_number: reference_number, entry_date: entry_date,
      debit_amounts_attributes: [account_id: debit_account.id, amount: amount],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount])
    end
    def debit_account
      find_employee.cash_on_hand_account
    end
  end
end
