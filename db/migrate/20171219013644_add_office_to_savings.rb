class AddOfficeToSavings < ActiveRecord::Migration[5.1]
  def change
    add_reference :savings, :office, foreign_key: true, type: :uuid
  end
end
