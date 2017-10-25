class CreateBreakContractFees < ActiveRecord::Migration[5.1]
  def change
    create_table :break_contract_fees, id: :uuid do |t|
      t.belongs_to :time_deposit_product, foreign_key: true, type: :uuid
      t.belongs_to :account, foreign_key: true, type: :uuid
      t.decimal :amount
      t.decimal :rate
      t.integer :fee_type

      t.timestamps
    end
  end
end
