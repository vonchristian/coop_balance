class LoanChargePaymentSchedule < ApplicationRecord
  belongs_to :loan_charge, class_name: "LoansModule::LoanCharge"
  validates :amount, numericality: true, presence: true
  validates :date, presence: true
end
