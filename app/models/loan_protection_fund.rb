class LoanProtectionFund < ApplicationRecord
  belongs_to :loan
  belongs_to :loan_protection_rate
end
