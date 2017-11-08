class CreateLoanInterestConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_interest_configs, id: :uuid do |t|
      t.belongs_to :account, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
