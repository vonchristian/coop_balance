class CreateLoanApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_approvals, id: :uuid do |t|
      t.integer :status
      t.datetime :date_approved
      t.belongs_to :approver, foreign_key: { to_table: :users }, type: :uuid
      t.belongs_to :loan, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :loan_approvals, :status
  end
end
