class AddLedgerToOfficePrograms < ActiveRecord::Migration[6.1]
  def change
    add_reference :office_programs, :ledger, foreign_key: true, type: :uuid
  end
end
