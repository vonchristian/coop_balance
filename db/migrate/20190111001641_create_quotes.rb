class CreateQuotes < ActiveRecord::Migration[5.2]
  def change
    create_table :quotes, id: :uuid do |t|
      t.text :content
  
      t.timestamps
    end
  end
end
