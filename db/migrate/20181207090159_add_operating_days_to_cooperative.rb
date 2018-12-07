class AddOperatingDaysToCooperative < ActiveRecord::Migration[5.2]
  def change
    add_column :cooperatives, :operating_days, :string, array: true, default: '{}'
  end
end
