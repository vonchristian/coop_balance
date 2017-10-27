module Addresses
  class Barangay < ApplicationRecord
    belongs_to :municipality
    has_many :streets 
    has_many :loans, class_name: "LoansModule::Loan"
    validates :name, presence: true, uniqueness: true
  end
end