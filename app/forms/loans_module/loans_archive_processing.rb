module LoansModule
  class LoansArchiveProcessing
    include ActiveModel::Model
    attr_accessor :loan_ids, :cooperative_id, :employee_id

    def archive!
      return if find_loans.blank?

      find_loans.each do |loan|
        loan.update(
          archived: true,
          archiving_date: Time.zone.today,
          archived_by: find_employee
        )
      end
    end

    def find_loans
      find_cooperative.loans.where(id: loan_ids)
    end

    def find_cooperative
      Cooperative.find(cooperative_id)
    end

    def find_employee
      User.find(employee_id)
    end
  end
end
