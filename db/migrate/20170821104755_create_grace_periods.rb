class CreateGracePeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :grace_periods, id: :uuid do |t|
      t.decimal :number_of_days

      t.timestamps
    end
  end
end
