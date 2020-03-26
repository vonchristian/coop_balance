class CreateCooperativeBankingAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :cooperative_banking_agents, id: :uuid do |t|
      t.belongs_to :cooperative, null: false, foreign_key: true, type: :uuid 
      t.belongs_to :banking_agent, null: false, foreign_key: true, type: :uuid 

      t.timestamps
    end
  end
end
