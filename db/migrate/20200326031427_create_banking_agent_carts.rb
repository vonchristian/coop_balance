class CreateBankingAgentCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :banking_agent_carts, id: :uuid do |t|
      t.belongs_to :banking_agent, null: false, foreign_key: true, type: :uuid 

      t.timestamps
    end
  end
end
