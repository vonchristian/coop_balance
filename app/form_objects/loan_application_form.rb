class LoanApplicationForm
	include ActiveModel::Model 
	attr_accessor :loan_product_id, 
	:loan_amount, 
	:member_id,
	:term,
	:application_date, 
	:duration
	validates :member_id,  :loan_amount, :term, :loan_product_id, presence: true

  def save 
	  ActiveRecord::Base.transaction do
      create_loan
    end
  end
  def find_loan
  	LoansModule::Loan.find_by(id: loan_product_id: loan_product_id, member_id: member_id, loan_amount: loan_amount, application_date: application_date, term: term)
  end

  private 
  def create_loan
  	LoansModule::Loan.create!(loan_product_id: loan_product_id, member_id: member_id, loan_amount: loan_amount, application_date: application_date, term: term)
  end
end

