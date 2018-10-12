class CreateEmployeeCashAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_cash_accounts, id: :uuid do |t|
      t.belongs_to :employee, foreign_key: { to_table: :users }, type: :uuid
      t.belongs_to :cash_account, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
