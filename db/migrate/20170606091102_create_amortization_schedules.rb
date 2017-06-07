class CreateAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :amortization_schedules, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.datetime :date
      t.decimal :principal
      t.decimal :interest

      t.timestamps
    end
  end
end
