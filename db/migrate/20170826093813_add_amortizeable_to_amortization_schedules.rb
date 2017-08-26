class AddAmortizeableToAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_reference :amortization_schedules, :amortizeable, polymorphic: true, type: :uuid, index: {name: 'amortization_schedules_amortizeable_index'}
  end
end
