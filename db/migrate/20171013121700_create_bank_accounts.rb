class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts, id: :uuid do |t|
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.string :bank_name
      t.string :bank_address
      t.string :account_number

      t.timestamps
    end
  end
end
