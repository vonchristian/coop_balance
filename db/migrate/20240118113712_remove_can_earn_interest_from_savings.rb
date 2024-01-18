class RemoveCanEarnInterestFromSavings < ActiveRecord::Migration[7.1]
  def change
    remove_column :savings, :can_earn_interest, :boolean
  end
end
