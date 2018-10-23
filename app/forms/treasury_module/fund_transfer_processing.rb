module TreasuryModule
  class FundTransferProcessing
    include ActiveModel::Model
    attr_accessor :employee_id,
    :amount,
    :entry_date,
    :description,
    :reference_number,
    :receiver_id

    validates :amount,  presence: true, numericality: true
    validates :reference_number, :description, :receiver_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_fund_transfer
      end
    end
    private
    def find_employee
      User.find_by(id: employee_id)
    end
    def find_receiver
      User.find_by(id: receiver_id)
    end

    def save_fund_transfer
      entry = AccountingModule::Entry.create!(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        recorder: find_employee,
        commercial_document: find_receiver,
        description: description,
        reference_number: reference_number,
        entry_date: entry_date,
      debit_amounts_attributes: [
        account: debit_account,
        amount: amount,
        commercial_document: find_receiver],
      credit_amounts_attributes: [
        account: credit_account,
        amount: amount,
        commercial_document: find_receiver])


        entry.set_previous_entry!
        entry.set_hashes!
    end

    def debit_account
      if find_receiver.present?
        find_receiver.cash_on_hand_account
      else
        find_employee.office.cash_in_vault_account
      end
    end
     def credit_account
      find_employee.cash_on_hand_account
    end
  end
end
