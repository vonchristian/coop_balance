class CreateNotices < ActiveRecord::Migration[5.1]
  def change
    create_table :notices, id: :uuid do |t|
      t.datetime :date
      t.string :type
      t.references :notified, polymorphic: true
      t.string :title
      t.text :content

      t.timestamps
    end
    add_index :notices, :type
  end
end
