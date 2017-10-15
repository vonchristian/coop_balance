class Contribution < ApplicationRecord
  has_many :employee_contributions
  has_many :contributors, class_name: "User", through: :employee_contributions
  validates :name, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: true
end
