class AddOrganizationToTimeDeposits < ActiveRecord::Migration[5.2]
  def change
    add_reference :time_deposits, :organization, foreign_key: true, type: :uuid
  end
end
