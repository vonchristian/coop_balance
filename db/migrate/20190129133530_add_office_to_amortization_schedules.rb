class AddOfficeToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :amortization_schedules, :office, foreign_key: true, type: :uuid
  end
end
