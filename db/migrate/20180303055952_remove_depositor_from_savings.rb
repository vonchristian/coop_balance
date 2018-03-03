class RemoveDepositorFromSavings < ActiveRecord::Migration[5.2]
  def change
    remove_reference :savings, :depositor, polymorphic: true, type: :uuid
  end
end
