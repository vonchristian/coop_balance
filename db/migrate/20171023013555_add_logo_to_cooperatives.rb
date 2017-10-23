class AddLogoToCooperatives < ActiveRecord::Migration[5.1]
  def up
    add_attachment :cooperatives, :logo
  end
  def down
    remove_attachment :cooperatives, :logo
  end
end
