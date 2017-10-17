class CreateMunicipalities < ActiveRecord::Migration[5.1]
  def change
    create_table :municipalities, id: :uuid do |t|
      t.string :name, index: true, unique: true
      
      t.timestamps
    end
  end
end
