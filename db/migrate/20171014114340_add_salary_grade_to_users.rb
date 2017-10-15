class AddSalaryGradeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :salary_grade, foreign_key: true, type: :uuid
  end
end
