class AddSubscribersToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_reference :share_capitals, :subscriber, polymorphic: true, type: :uuid
  end
end
