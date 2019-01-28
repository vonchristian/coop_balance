class AddEntryIdsToAmortizationSchedule < ActiveRecord::Migration[5.2]
  def change
  	add_column :amortization_schedules, :entry_ids, :string, array: true, default: "{}"
  end
end
