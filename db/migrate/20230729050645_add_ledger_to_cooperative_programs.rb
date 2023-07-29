class AddLedgerToCooperativePrograms < ActiveRecord::Migration[6.1]
  def change
    add_reference :programs, :ledger, foreign_key: true, type: :uuid
  end
end
