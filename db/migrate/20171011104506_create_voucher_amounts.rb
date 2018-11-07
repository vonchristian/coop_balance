class CreateVoucherAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :voucher_amounts, id: :uuid do |t|
      t.monetize :amount, limit: 12, default: 0, null: false
      t.belongs_to :account, foreign_key: true, type: :uuid
      t.belongs_to :voucher, foreign_key: true, type: :uuid
      t.references :commercial_document, polymorphic: true,  type: :uuid, index: {name: "index_on_commercial_document_voucher_amount" }
      t.timestamps
    end
  end
end
