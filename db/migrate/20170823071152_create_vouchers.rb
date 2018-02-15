class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers, id: :uuid do |t|
      t.string :number
      t.datetime :date
      t.references :voucherable, polymorphic: true, type: :uuid
      t.references :payee, polymorphic: true, type: :uuid


      t.timestamps
    end
  end
end
