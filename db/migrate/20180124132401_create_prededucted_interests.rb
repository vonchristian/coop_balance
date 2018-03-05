class CreatePredeductedInterests < ActiveRecord::Migration[5.1]
  def change
    create_table :prededucted_interests, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.datetime :posting_date
      t.decimal :amount
      t.belongs_to :debit_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :credit_account, foreign_key: { to_table: :accounts }, type: :uuid

      t.references :commercial_document, polymorphic: true, type: :uuid, index: { name: "index_commercial_document_on_prededucted_interests" }

      t.timestamps
    end
  end
end
