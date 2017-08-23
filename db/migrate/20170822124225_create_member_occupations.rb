class CreateMemberOccupations < ActiveRecord::Migration[5.1]
  def change
    create_table :member_occupations, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.belongs_to :occupation, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
