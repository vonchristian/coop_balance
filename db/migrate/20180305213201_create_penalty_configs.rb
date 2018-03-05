class CreatePenaltyConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :penalty_configs, id: :uuid do |t|
      t.belongs_to :loan_product, foreign_key: true, type: :uuid
      t.decimal :rate
      t.belongs_to :penalty_receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :penalty_revenue_account, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
