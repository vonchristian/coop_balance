class DropBankingAgentCarts < ActiveRecord::Migration[7.0]
  def up
    drop_table :banking_agent_carts
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
