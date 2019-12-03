module LoansModule
  class LoanAgingGroup < ApplicationRecord
    validates :title, :start_num, :end_num, presence: true
    validates :start_num, :end_num, numericality: true
  end
end
