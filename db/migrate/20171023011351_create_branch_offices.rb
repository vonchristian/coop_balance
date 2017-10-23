class CreateBranchOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :branch_offices, id: :uuid do |t|
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.string :address
      t.string :branch_name, :unique => true
      t.string :contact_number

      t.timestamps
    end
  end
end
