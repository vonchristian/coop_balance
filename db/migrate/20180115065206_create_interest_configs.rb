class CreateInterestConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :interest_configs, id: :uuid do |t|
      t.belongs_to :loan_product, foreign_key: true, type: :uuid
      t.belongs_to :earned_interest_income_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :interest_receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :unearned_interest_income_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.decimal :rate

      t.timestamps
    end
  end
end
