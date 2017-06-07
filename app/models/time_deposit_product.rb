class TimeDepositProduct < ApplicationRecord
  enum interest_recurrence: [:weekly, :monthly, :annually]
  def self.set_product_for(time_deposit)
    time_deposit.time_deposit_product = all.select{|a| a.range.include?(time_deposit.balance) }.first
    time_deposit.save
  end
  def range
    minimum_amount..maximum_amount
  end
end
