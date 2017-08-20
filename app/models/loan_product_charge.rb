class LoanProductCharge < ApplicationRecord
  belongs_to :charge
  belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
end
