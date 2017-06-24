class CreateProgramSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :program_subscriptions, id: :uuid do |t|
      t.belongs_to :program, foreign_key: true, type: :uuid
      t.belongs_to :member, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
