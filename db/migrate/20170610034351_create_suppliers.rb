class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :contact_number

      t.timestamps
    end
  end
end
