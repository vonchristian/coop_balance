module TreasuryModule
  class VaultFundTransferProcessing
    include ActiveModel::Model
    attr_accessor :employee_id,
                  :amount,
                  :entry_date,
                  :description,
                  :reference_number

    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_fund_transfer
      end
    end

    private

    def find_employee
      User.find_by(id: employee_id)
    end

    def find_office
      find_employee.office
    end

    def save_fund_transfer
      AccountingModule::Entry.create!(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        recorder: find_employee,
        commercial_document: find_employee,
        description: description,
        reference_number: reference_number,
        entry_date: entry_date,
        debit_amounts_attributes: [
          account: debit_account,
          amount: amount
        ],
        credit_amounts_attributes: [
          account: credit_account,
          amount: amount
        ]
      )
    end

    def debit_account
      find_office.cash_in_vault_account
    end

    def credit_account
      find_employee.cash_on_hand_account
    end
  end
end
