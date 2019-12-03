class CreateLoanAgings < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_agings, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.belongs_to :loan_aging_group, foreign_key: true, type: :uuid
      t.datetime :date
      
      t.timestamps
    end
  end
end
