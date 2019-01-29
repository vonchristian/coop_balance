class AddOfficeToRegistries < ActiveRecord::Migration[5.2]
  def change
    add_reference :registries, :office, foreign_key: true, type: :uuid
  end
end
