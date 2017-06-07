class CreateCapitalBuildUps < ActiveRecord::Migration[5.1]
  def change
    create_table :capital_build_ups, id: :uuid do |t|
      t.belongs_to :share_capital, foreign_key: true, type: :uuid
      t.decimal :share_count
      t.datetime :date

      t.timestamps
    end
  end
end
