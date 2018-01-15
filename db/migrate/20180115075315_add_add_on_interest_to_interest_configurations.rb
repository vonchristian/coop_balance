class AddAddOnInterestToInterestConfigurations < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :add_on_interest, :boolean
  end
end
