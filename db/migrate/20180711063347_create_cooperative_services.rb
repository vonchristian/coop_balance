class CreateCooperativeServices < ActiveRecord::Migration[5.2]
  def change
    create_table :cooperative_services, id: :uuid do |t|
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.string :title

      t.timestamps
    end
  end
end
