class ChangeLoanTermApplications < ActiveRecord::Migration[5.2]
  def change
    change_column :loan_applications, :term, :decimal, null: false
  end
end
