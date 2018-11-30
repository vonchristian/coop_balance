class AddCooperativeToSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_reference :suppliers, :cooperative, foreign_key: true, type: :uuid
  end
end
