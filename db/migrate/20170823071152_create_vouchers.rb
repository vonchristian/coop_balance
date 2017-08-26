class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers, id: :uuid do |t|
      t.string :number
      t.datetime :date
      t.references :voucherable, polymorphic: true
      t.references :payee, polymorphic: true


      t.timestamps
    end
  end
end
