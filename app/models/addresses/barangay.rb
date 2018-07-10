module Addresses
  class Barangay < ApplicationRecord
    belongs_to :municipality
    has_many :streets
    has_many :loans, class_name: "LoansModule::Loan"
    has_many :savings, class_name: "MembershipsModule::Saving"
    validates :name, presence: true, uniqueness: true
    has_many :addresses
    has_many :members, through: :addresses, source: :addressable, source_type: "Member"
  end
end
