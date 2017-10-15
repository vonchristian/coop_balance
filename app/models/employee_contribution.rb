class EmployeeContribution < ApplicationRecord
  belongs_to :employee, class_name: "User", foreign_key: 'employee_id'
  belongs_to :contribution
end
