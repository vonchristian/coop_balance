class AddProvinceIdToMunicipalities < ActiveRecord::Migration[5.2]
  def change
    add_reference :municipalities, :province, foreign_key: true, type: :uuid
  end
end
