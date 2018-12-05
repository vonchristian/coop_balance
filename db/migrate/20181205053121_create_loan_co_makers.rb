class CreateLoanCoMakers < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_co_makers, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.references :co_maker, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
