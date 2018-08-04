class AddTrackingNumberToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :tracking_number, :string
  end
end
