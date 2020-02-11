class AddRefNumberIntegerToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :ref_number_integer, :integer
  end
end
