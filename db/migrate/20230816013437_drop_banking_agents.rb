class DropBankingAgents < ActiveRecord::Migration[7.0]
  def up
    drop_table :banking_agents
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
