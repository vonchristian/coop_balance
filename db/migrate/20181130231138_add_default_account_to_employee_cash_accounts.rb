class AddDefaultAccountToEmployeeCashAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_cash_accounts, :default_account, :boolean, default: false
  end
end
