class AddSupplierIdToRegistries < ActiveRecord::Migration[5.1]
  def change
    add_reference :registries, :supplier, foreign_key: true, type: :uuid
  end
end
