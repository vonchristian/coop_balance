class RemoveOfficeFromPrograms < ActiveRecord::Migration[6.0]
  def change
    remove_reference :programs, :office, null: false, foreign_key: true, type: :uuid
  end
end
