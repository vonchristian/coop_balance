class CreateLoanPenaltyConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_penalty_configs, id: :uuid do |t|
      t.decimal :number_of_days
      t.decimal :interest_rate

      t.timestamps
    end
  end
end
