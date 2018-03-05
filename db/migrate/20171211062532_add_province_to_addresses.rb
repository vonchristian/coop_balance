class AddProvinceToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_reference :addresses, :province, foreign_key: true, type: :uuid
  end
end
