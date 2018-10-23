class CreateShareCapitalApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :share_capital_applications, id: :uuid do |t|
      t.references :subscriber, polymorphic: true, type: :uuid, index: { name: "index_subscriber_on_share_capital_applications" }
      t.belongs_to :share_capital_product, foreign_key: true, type: :uuid
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.belongs_to :office, foreign_key: true, type: :uuid
      t.decimal :initial_capital
      t.string :account_number
      t.datetime :date_opened

      t.timestamps
    end
  end
end
