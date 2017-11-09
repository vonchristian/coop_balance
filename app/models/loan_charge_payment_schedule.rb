class LoanChargePaymentSchedule < ApplicationRecord
  belongs_to :loan_charge, class_name: "LoansModule::LoanCharge"
  validates :amount, numericality: true, presence: true
  validates :date, presence: true

  delegate :name, to: :loan_charge
  def self.scheduled_for(month)
    where('loan_charge_payment_schedules.date' => (month.beginning_of_month)..(month.end_of_month))
  end
end
