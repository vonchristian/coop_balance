class RemoveLoanTermFromLoans < ActiveRecord::Migration[6.0]
  def change
    remove_reference :loans, :term,  foreign_key: true, type: :uuid 
  end
end
