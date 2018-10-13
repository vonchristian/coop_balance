class CreateTimeDepositApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :time_deposit_applications, id: :uuid do |t|
      t.references :depositor, polymorphic: true, type: :uuid, index: { name: "index_depositor_on_time_deposit_applications" }
      t.string :account_number
      t.datetime :date_deposited
      t.decimal :term
      t.decimal :amount
      t.belongs_to :voucher, foreign_key: true, type: :uuid
      t.belongs_to :time_deposit_product, foreign_key: true, type: :uuid


      t.timestamps
    end
    add_index :time_deposit_applications, :account_number, unique: true
  end
end
