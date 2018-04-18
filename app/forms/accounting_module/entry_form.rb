module AccountingModule
  class EntryForm
    include ActiveModel::Model
    attr_accessor :recorder_id, :amount, :debit_account_id, :credit_account_id, :entry_date, :description, :reference_number

    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, :debit_account_id, :credit_account_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_entry
      end
    end

    def save_entry
      AccountingModule::Entry.create(
      origin: find_employee.office,
      recorder: find_employee,
      description: description,
      reference_number: reference_number,
      entry_date: entry_date,
      debit_amounts_attributes: [account_id: debit_account_id, amount: amount, commercial_document: find_employee],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount, commercial_document: find_employee])
    end
    def find_employee
      User.find_by_id(recorder_id)
    end
  end
end
