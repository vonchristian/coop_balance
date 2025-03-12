class CreateBankingAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :banking_agents, id: :uuid do |t|
      t.string :name
      t.string :account_number
      t.belongs_to :depository_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
