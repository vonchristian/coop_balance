class CreateSavingsAccountConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :savings_account_configs, id: :uuid do |t|
      t.decimal :closing_account_fee

      t.timestamps
    end
  end
end
