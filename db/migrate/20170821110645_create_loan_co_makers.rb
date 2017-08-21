class CreateLoanCoMakers < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_co_makers, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.belongs_to :co_maker, foreign_key: { to_table: :members }, type: :uuid

      t.timestamps
    end
  end
end
