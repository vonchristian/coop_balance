class Department < ApplicationRecord
	has_many :employees, class_name: "User"
end
