class AddAccruedIncomeAccountToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_reference :interest_configs, :accrued_income_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
