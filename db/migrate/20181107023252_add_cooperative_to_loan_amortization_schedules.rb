class AddCooperativeToLoanAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :amortization_schedules, :cooperative, foreign_key: true, type: :uuid
  end
end
