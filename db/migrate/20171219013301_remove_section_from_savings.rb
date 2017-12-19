class RemoveSectionFromSavings < ActiveRecord::Migration[5.2]
  def change
    remove_reference :savings, :section, foreign_key: true, type: :uuid
  end
end
