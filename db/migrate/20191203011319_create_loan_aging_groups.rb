class CreateLoanAgingGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_aging_groups, id: :uuid do |t|
      t.string :title
      t.integer :start_num
      t.integer :end_num
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid 

      t.timestamps
    end
  end
end
