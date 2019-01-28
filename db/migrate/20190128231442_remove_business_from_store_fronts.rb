class RemoveBusinessFromStoreFronts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :store_fronts, :business, polymorphic: true, type: :uuid
  end
end
