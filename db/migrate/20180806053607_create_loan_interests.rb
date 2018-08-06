class CreateLoanInterests < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_interests, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.decimal :amount
      t.datetime :date
      t.string :description

      t.timestamps
    end
  end
end
