module AccountingModule
  class AdjustingEntry
    include ActiveModel::Model
    attr_accessor :entry_date,
                  :reference_number,
                  :description,
                  :amount,
                  :employee_id,
                  :commercial_document_id,
                  :commercial_document_type,
                  :debit_account_id,
                  :credit_account_id
    validates :entry_date,
              :reference_number,
              :description,
              :amount,
              :debit_account_id,
              :credit_account_id,
              presence: true
    validates :amount, numericality: true
    def save
      ActiveRecord::Base.transaction do
        create_entry
      end
    end

    private
    def create_entry
      AccountingModule::Entry.create!(
        entry_date: entry_date,
        origin: find_employee.office,
        recorder: find_employee,
        description: "ADJUSTING ENTRY: #{description}",
        commercial_document_id: commercial_document_id,
        commercial_document_type: commercial_document_type,
        reference_number: reference_number,
        debit_amounts_attributes: [
          amount: amount,
          account_id: debit_account_id,
          commercial_document_id: commercial_document_id,
          commercial_document_type: commercial_document_type
        ],
        credit_amounts_attributes: [
          amount: amount,
          account_id: credit_account_id,
          commercial_document_id: commercial_document_id,
          commercial_document_type: commercial_document_type
        ]
      )
    end
    def find_employee
      User.find_by_id(employee_id)
    end
  end
end
