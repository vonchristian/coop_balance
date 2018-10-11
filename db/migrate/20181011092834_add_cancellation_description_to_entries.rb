class AddCancellationDescriptionToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :cancellation_description, :string
  end
end
