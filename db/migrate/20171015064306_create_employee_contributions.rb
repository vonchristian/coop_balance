class CreateEmployeeContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_contributions, id: :uuid do |t|
      t.belongs_to :employee, foreign_key: { to_table: :users }, type: :uuid
      t.belongs_to :contribution, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
