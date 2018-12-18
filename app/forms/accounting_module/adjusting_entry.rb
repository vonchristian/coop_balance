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
      entry = AccountingModule::Entry.create!(
        entry_date:          entry_date,
        recorder:            find_employee,
        office:              find_employee.office,
        cooperative:         find_employee.cooperative,
        description:         "ADJUSTING ENTRY: #{description}",
        commercial_document: find_commercial_document,
        reference_number:    reference_number,
        debit_amounts_attributes: [
          amount:              amount,
          account_id:          debit_account_id,
          commercial_document: find_commercial_document
        ],
        credit_amounts_attributes: [
          amount:              amount,
          account_id:          credit_account_id,
          commercial_document: find_commercial_document
        ]
      )
    end

    def find_employee
      User.find_by_id(employee_id)
    end
    
    def find_commercial_document
      commercial_document_type.constantize.find(commercial_document_id)
    end
  end
end
