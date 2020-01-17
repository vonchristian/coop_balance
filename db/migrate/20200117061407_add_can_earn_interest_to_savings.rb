class AddCanEarnInterestToSavings < ActiveRecord::Migration[6.0]
  def change
    add_column :savings, :can_earn_interest, :boolean, default: false 
  end
end
