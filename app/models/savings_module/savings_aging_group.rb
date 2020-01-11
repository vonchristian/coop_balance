module SavingsModule
  class SavingsAgingGroup < ApplicationRecord
    belongs_to :office, class_name: 'Cooperatives::Office'

    validates :title, :start_num, :end_num, presence: true 
    validates :title, uniqueness: { scope: :office_id }
  end
end 
