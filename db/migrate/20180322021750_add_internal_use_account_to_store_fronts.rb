class AddInternalUseAccountToStoreFronts < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_fronts, :internal_use_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
