class CreateSavingsAccountApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :savings_account_applications, id: :uuid do |t|
      t.references :depositor, polymorphic: true, type: :uuid, index: { name: "index_depositor_on_savings_account_applications" }
      t.belongs_to :saving_product, foreign_key: true, type: :uuid
      t.datetime :date_opened
      t.decimal :initial_deposit
      t.string :account_number

      t.timestamps
    end
  end
end
