module LoansModule
  class LoanProtectionPlanProvider < ApplicationRecord
    belongs_to :cooperative
    belongs_to :accounts_payable, class_name: "AccountingModule::Account"

    validates :business_name, presence: true, uniqueness: { scope: :cooperative_id }
  end
end
