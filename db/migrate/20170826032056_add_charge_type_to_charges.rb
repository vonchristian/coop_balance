class AddChargeTypeToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :type, :string, index: true
  end
end
