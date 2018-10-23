module BankAccounts
  class DepositProcessing
    include ActiveModel::Model
    attr_accessor :bank_account_id, :description, :recorder_id, :amount, :reference_number, :date

    validates  :amount, :description, :reference_number, :date, presence: true
    validates :amount, numericality: true

    def save
      ActiveRecord::Base.transaction do
        save_entry
      end
    end

    def find_bank_account
      BankAccount.find_by(id: bank_account_id)
    end

    def save_entry
      entry = AccountingModule::Entry.create!(
      commercial_document: find_bank_account,
      recorder: find_employee,
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      description: description,
      reference_number: reference_number,
      entry_date: date,
      debit_amounts_attributes: [
        account: credit_account,
        amount: amount,
        commercial_document: find_bank_account],
      credit_amounts_attributes: [
        account: debit_account,
        amount: amount,
        commercial_document: find_bank_account])
        entry.set_previous_entry!
        entry.set_hashes!
    end

    def find_employee
      User.find(recorder_id)
    end

    def debit_account
      find_employee.cash_on_hand_account
    end

    def credit_account
      find_bank_account.account
    end
  end
end
