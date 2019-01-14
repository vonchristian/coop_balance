class CreateLeads < ActiveRecord::Migration[5.2]
  def change
    create_table :leads, id: :uuid do |t|
      t.string :email
      t.string :contact_number

      t.timestamps
    end
  end
end
