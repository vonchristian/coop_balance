module BankAccounts
  class Opening
    include ActiveModel::Model
    attr_accessor :bank_name, :bank_address, :account_number,  :amount, :recorder_id, :account_id, :earned_interest_account_id, :date, :reference_number, :description, :cash_account_id
    validates :amount, presence: true, numericality: { greater_than: 0.01 }
    validates :bank_name, :bank_address, :account_number, :account_id, :earned_interest_account_id, :date, :reference_number, :description, presence: true

    def process!
      ActiveRecord::Base.transaction do
        open_bank_account
      end
    end

    private
    def open_bank_account
      bank_account = BankAccount.find_or_create_by!(
        bank_name:                  bank_name,
        bank_address:               bank_address,
        account_number:             account_number,
        account_id:                 account_id,
        earned_interest_account_id: earned_interest_account_id,
        cooperative:             find_employee.cooperative)

      AccountingModule::Entry.create!(
        commercial_document: bank_account,
        office:              find_employee.office,
        cooperative:         find_employee.cooperative,
        recorder:            find_employee,
        entry_date:          date,
        reference_number:    reference_number,
        description:         description,
        credit_amounts_attributes: [
          account:             cash_account,
          amount:              amount,
          commercial_document: bank_account],
        debit_amounts_attributes: [
          account_id:          account_id,
          amount:              amount,
          commercial_document: bank_account])
    end

    def find_employee
      User.find(recorder_id)
    end

    def cash_account
      AccountingModule::Account.find(cash_account_id)
    end
  end
end
