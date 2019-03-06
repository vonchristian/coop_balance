class CreateCashCountReports < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_count_reports, id: :uuid do |t|
      t.belongs_to :employee, foreign_key: { to_table: :users }, type: :uuid
      t.datetime :date
      t.decimal :beginning_balance, default: 0, null: false
      t.decimal :ending_balance,  default: 0, null: false
      t.decimal :difference,  default: 0, null: false
      t.string :description

      t.timestamps
    end
  end
end
