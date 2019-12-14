class AddDateWithdrawnToShareCapitals < ActiveRecord::Migration[6.0]
  def change
    add_column :share_capitals, :withdrawn_at, :datetime
  end
end
