module HrModule
  class SalaryGrade < ApplicationRecord
    has_many :employees, class_name: "User"
  end
end
