class AddDepositorsToSavings < ActiveRecord::Migration[5.1]
  def change
    add_reference :savings, :depositor, polymorphic: true, type: :uuid
  end
end
