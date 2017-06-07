class SavingProduct < ApplicationRecord
  enum interest_recurrence: [:daily, :weekly, :monthly, :quarterly, :annually]
end
