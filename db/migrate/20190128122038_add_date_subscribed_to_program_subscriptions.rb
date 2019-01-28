class AddDateSubscribedToProgramSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :program_subscriptions, :date_subscribed, :datetime
  end
end
