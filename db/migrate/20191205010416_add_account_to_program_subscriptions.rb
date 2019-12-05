class AddAccountToProgramSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_reference :program_subscriptions, :account, foreign_key: true, type: :uuid 
  end
end
