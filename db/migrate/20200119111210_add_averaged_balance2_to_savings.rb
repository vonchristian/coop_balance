class AddAveragedBalance2ToSavings < ActiveRecord::Migration[6.0]
  def change
    add_monetize :savings, :averaged_balance
  end
end
