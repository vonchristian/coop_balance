module LoansModule
  class LoanAgingGroup < ApplicationRecord
    belongs_to :office, class_name: 'Cooperatives::Office'
    validates :title, :start_num, :end_num, presence: true
    validates :start_num, :end_num, numericality: true

    def num_range
      start_num..end_num
    end
  end
end
