class AddPaymentScheduleTypeToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :payment_schedule_type, :integer
    add_index :programs, :payment_schedule_type
  end
end
