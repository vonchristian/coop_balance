module LoansModule
  class LoanAgingGroup < ApplicationRecord
    belongs_to :office,    class_name: 'Cooperatives::Office'
    has_many :loan_agings, class_name: 'LoansModule::Loans::LoanAging'
    has_many :loans,       class_name: 'LoansModule::Loan', through: :loan_agings 

    validates :title, :start_num, :end_num, presence: true
    validates :start_num, :end_num, numericality: true

    def num_range
      start_num..end_num
    end
  end
end
