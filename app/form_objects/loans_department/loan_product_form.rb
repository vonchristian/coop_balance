module LoansDepartment
  class LoanProductForm < Reform::Form
    property :name
    property :description
    property :interest_rate
    property :interest_recurrence
    validates :name, presence: true
    validates :interest_rate, numericality: true, presence: true
    validates_uniqueness_of :name, case_sensitive: false
  end
end
