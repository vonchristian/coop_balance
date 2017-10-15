class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions, id: :uuid do |t|
      t.string :name
      t.decimal :amount

      t.timestamps
    end
  end
end
