class AddSectionToSavings < ActiveRecord::Migration[5.1]
  def change
    add_reference :savings, :section, foreign_key: true, type: :uuid
  end
end
