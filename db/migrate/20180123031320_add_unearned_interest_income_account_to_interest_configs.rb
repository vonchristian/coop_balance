class AddUnearnedInterestIncomeAccountToInterestConfigs < ActiveRecord::Migration[5.1]
  def change
    add_reference :interest_configs, :unearned_interest_income_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
