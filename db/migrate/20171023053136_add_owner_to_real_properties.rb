class AddOwnerToRealProperties < ActiveRecord::Migration[5.1]
  def change
    add_reference :real_properties, :owner, polymorphic: true, type: :uuid
  end
end
