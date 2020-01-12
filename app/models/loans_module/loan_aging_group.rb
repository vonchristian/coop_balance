module LoansModule
  class LoanAgingGroup < ApplicationRecord
    belongs_to :office,                           class_name: 'Cooperatives::Office'
    has_many   :loan_agings,                      class_name: 'LoansModule::Loans::LoanAging'
    has_many   :loans,                            class_name: 'LoansModule::Loan', through: :loan_agings 
    has_many   :office_loan_product_aging_groups, class_name: 'LoansModule::OfficeLoanProductAgingGroup'
    has_many   :office_loan_products,             through: :office_loan_product_aging_groups, class_name: 'Offices::OfficeLoanProduct'
    
    validates :title, :start_num, :end_num, presence: true
    validates :start_num, :end_num, numericality: true
    
    delegate :level_one_account_category, to: :current_office_loan_product_aging_group
   
    def current_office_loan_product_aging_group
      office_loan_product_aging_groups.current 
    end 
    
    def num_range
      start_num..end_num
    end
   
    def total_balance(args={})
      level_one_account_category.balance(args)
    end 
  end
end
