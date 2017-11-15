class CreateInterestRebateConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :interest_rebate_configs, id: :uuid do |t|
      t.decimal :percent

      t.timestamps
    end
  end
end
