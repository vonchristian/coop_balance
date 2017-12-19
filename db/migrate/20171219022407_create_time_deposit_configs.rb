class CreateTimeDepositConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :time_deposit_configs, id: :uuid do |t|
      t.belongs_to :break_contract_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :interest_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :account, foreign_key: { to_table: :accounts }, type: :uuid
      t.decimal :break_contract_fee

      t.timestamps
    end
  end
end
