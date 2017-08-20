class LoanProductModeOfPayment < ApplicationRecord
  belongs_to :loan_product
  belongs_to :mode_of_payment
end
