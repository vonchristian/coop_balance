class CreateNetIncomeDistributions < ActiveRecord::Migration[5.2]
  def change
    create_table :net_income_distributions, id: :uuid do |t|
      t.belongs_to :account, foreign_key: true, type: :uuid
      t.decimal :rate
      t.string :description
      t.belongs_to :cooperative, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
