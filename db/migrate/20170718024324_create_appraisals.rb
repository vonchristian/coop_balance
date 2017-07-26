class CreateAppraisals < ActiveRecord::Migration[5.1]
  def change
    create_table :appraisals, id: :uuid do |t|
      t.belongs_to :real_property, foreign_key: true, type: :uuid
      t.decimal :market_value
      t.datetime :date_appraised
      t.belongs_to :appraiser, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
