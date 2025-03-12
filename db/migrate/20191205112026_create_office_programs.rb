class CreateOfficePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :office_programs, id: :uuid do |t|
      t.belongs_to :program, null: false, foreign_key: true, type: :uuid
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.belongs_to :level_one_account_category, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
