class AddBusinessToStoreFronts < ActiveRecord::Migration[5.2]
  def change
    add_reference :store_fronts, :business, polymorphic: true, type: :uuid
  end
end
