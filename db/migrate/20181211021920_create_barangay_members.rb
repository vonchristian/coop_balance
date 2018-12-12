class CreateBarangayMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :barangay_members, id: :uuid do |t|
    	t.belongs_to :barangay, foreign_key: true, type: :uuid
    	t.string :member_type
      t.timestamps
    end
  end
end
