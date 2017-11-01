class AddAccountToCharges < ActiveRecord::Migration[5.1]
  def change
    add_reference :charges, :account, foreign_key: true, type: :uuid
  end
end
