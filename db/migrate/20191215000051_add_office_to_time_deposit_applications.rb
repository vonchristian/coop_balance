class AddOfficeToTimeDepositApplications < ActiveRecord::Migration[6.0]
  def change
    add_reference :time_deposit_applications, :office, foreign_key: true, type: :uuid
  end
end
