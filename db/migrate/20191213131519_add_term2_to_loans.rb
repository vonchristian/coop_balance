class AddTerm2ToLoans < ActiveRecord::Migration[6.0]
  def change
    add_reference :loans, :term, foreign_key: true, type: :uuid 
  end
end
