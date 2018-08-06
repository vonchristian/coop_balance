class RemoveInterestReceivableAccountFromInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    remove_reference :interest_configs, :interest_receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
