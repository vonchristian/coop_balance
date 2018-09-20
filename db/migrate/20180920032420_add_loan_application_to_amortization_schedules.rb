class AddLoanApplicationToAmortizationSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :amortization_schedules, :loan_application, foreign_key: true, type: :uuid
  end
end
