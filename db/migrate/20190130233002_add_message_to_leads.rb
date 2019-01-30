class AddMessageToLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :message, :text
  end
end
