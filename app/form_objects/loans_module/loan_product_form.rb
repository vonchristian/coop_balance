module LoansModule
  class LoanProductForm
    include ActiveModel::Model 
    attr_accessor :name, :description, :max_loanable_amount,  :interest_rate

    def save
    ActiveRecord::Base.transaction do
      create_loan_product
      create_entry
    end
  end
  end
end
