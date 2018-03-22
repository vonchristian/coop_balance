class AddSpoilageAccountToStoreFronts < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_fronts, :spoilage_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
