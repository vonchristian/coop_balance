class AddOfficeToProgramSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_reference :program_subscriptions, :office, foreign_key: true, type: :uuid
  end
end
