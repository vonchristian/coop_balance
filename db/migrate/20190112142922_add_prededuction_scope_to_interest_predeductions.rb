class AddPredeductionScopeToInterestPredeductions < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_predeductions, :prededuction_scope, :integer, default: 0
    add_index :interest_predeductions, :prededuction_scope
  end
end
