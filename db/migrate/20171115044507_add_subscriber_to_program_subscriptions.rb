class AddSubscriberToProgramSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :program_subscriptions, :subscriber, polymorphic: true, type: :uuid, index: { name: "index_subscriber_in_program_subscriptions" }
  end
end
