class AddDepositorToTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    add_reference :time_deposits, :depositor, polymorphic: true, type: :uuid
  end
end
