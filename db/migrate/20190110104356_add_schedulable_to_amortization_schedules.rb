class AddSchedulableToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :amortization_schedules, :scheduleable, polymorphic: true, type: :uuid, index: { name: 'index_schedulable_on_amortization_schedules' }
  end
end
