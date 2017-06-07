class Member < ApplicationRecord
  enum sex: [:male, :female, :other]
  has_many :loans, class_name: "LoansDepartment::Loan"
  has_many :addresses, as: :addressable
  has_many :savings
  has_many :share_capitals

  def full_name
    "#{last_name}, #{first_name} #{middle_name}."
  end
end
