module StoreFrontModule
  class SalesClerkRemittance
    include ActiveModel::Model
    attr_accessor :remitted_by_id, :remitted_to_id, :amount, :entry_date, :description, :reference_number

    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, :remitted_to_id, :remitted_by_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_remittance
      end
    end
    private
    def save_remittance
      AccountingModule::Entry.create!(recorder_id: remitted_by_id, commercial_document: find_remitted_to,  description: description, reference_number: reference_number, entry_date: entry_date,
      debit_amounts_attributes: [account_id: debit_account_id, amount: amount, commercial_document: find_remitted_to],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount, commercial_document: find_remitted_to])
    end

    def debit_account_id
      find_remitted_to.cash_on_hand_account_id
    end

    def credit_account
      User.find_by_id(remitted_by_id).cash_on_hand_account_id
    end
    def find_remitted_to
      User.find_by_id(remitted_to_id)
    end
  end
end
