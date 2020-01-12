module LoansModule
  class OfficeLoanProductAgingGroup < ApplicationRecord
    belongs_to :office_loan_product,        class_name: 'Offices::OfficeLoanProduct'
    belongs_to :loan_aging_group,           class_name: 'LoansModule::LoanAgingGroup'
    belongs_to :level_one_account_category, class_name: 'AccountingModule::LevelOneAccountCategory'
    
    delegate :title, to: :level_one_account_category, prefix: true
    def self.current 
      order(created_at: :desc).first 
    end 
  end
end 
