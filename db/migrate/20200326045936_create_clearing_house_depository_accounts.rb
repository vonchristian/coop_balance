class CreateClearingHouseDepositoryAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :clearing_house_depository_accounts, id: :uuid do |t|
      t.references :depositor, polymorphic: true, null: false, type: :uuid, index: { name: "index_depositor_on_clearing_house_dep_accounts" } 
      t.belongs_to :clearing_house, null: false, foreign_key: { to_table: :automated_clearing_houses }, type: :uuid 
      t.belongs_to :depository_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid , index: { name: "index_depository_account_on_clearing_house_dep_accounts" } 

      t.timestamps
    end
  end
end
