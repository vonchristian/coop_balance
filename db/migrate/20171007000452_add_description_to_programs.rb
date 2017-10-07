class AddDescriptionToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :description, :text
  end
end
