class AddCreatedAtToShareCapitals < ActiveRecord::Migration[5.1]
  def change
    change_table :share_capitals do |t|
      t.timestamps null: false, default: Time.zone.now
    end
  end
end
