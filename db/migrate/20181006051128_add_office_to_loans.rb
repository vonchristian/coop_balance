class AddOfficeToLoans < ActiveRecord::Migration[5.2]
  def change
    add_reference :loans, :office, foreign_key: true, type: :uuid
  end
end
