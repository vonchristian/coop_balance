class AddCooperativeToTimeDepositApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :time_deposit_applications, :cooperative, foreign_key: true, type: :uuid
  end
end
