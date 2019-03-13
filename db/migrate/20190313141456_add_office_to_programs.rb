class AddOfficeToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_reference :programs, :office, foreign_key: true, type: :uuid
  end
end
