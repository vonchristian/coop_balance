class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices, id: :uuid do |t|
      t.string :type
      t.references :invoicable, polymorphic: true
      t.string :number

      t.timestamps
    end
    add_index :invoices, :type
    add_index :invoices, :number, unique: true
  end
end
