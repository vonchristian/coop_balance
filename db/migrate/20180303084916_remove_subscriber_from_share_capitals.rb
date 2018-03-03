class RemoveSubscriberFromShareCapitals < ActiveRecord::Migration[5.2]
  def change
    remove_reference :share_capitals, :subscriber, polymorphic: true, type: :uuid
  end
end
