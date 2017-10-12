class AddNumberToRegistry < ActiveRecord::Migration[5.1]
  def change
    add_column :registries, :number, :string
  end
end
