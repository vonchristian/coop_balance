module LoansModule
  class LoansArchiveProcessing
    include ActiveModel::Model
    attr_accessor :loan_ids, :cooperative_id, :employee_id

    def archive!
      if find_loans.present?
      	find_loans.each do |loan|
      		loan.update_attributes!(
      			archived: true,
      			archiving_date: Date.today,
      			archived_by: find_employee
      		)
      	end
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