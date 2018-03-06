class AddDebitAccountToAmortizationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_reference :amortization_schedules, :debit_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :amortization_schedules, :credit_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :amortization_schedules, :commercial_document, polymorphic: true, type: :uuid, index: { name: "index_commercial_document_on_amortization_schedules" }
  end
end
